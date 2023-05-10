---
title: "Transformer: from attention to performance optimizations"
date: 2023-05-04T22:00+08:00
draft: true
---

The purpose of this post is to focus on understanding what is happening and the performance factors involved when fine-tuning and running local large language models, keeping multi-modality in mind.

To accomplish this, we first present a brief account of the transformer architecture, including its design intuitions and corresponding mathematical treatments, concretized by illustrative diagrams and code snippets. Then we aim to achieve a comprehensive understanding of the widely adopted performance optimizations for the original transformer architecture.

This post draws inspiration from [An Introduction to Transformers (Turner, 2023)](https://arxiv.org/abs/2304.10557) [^1], which provides a mathematically precise, intuitive, and clean description of the transformer architecture, gradually (Phuong et al., 2022)[^2] and other sources will be incorporated and improved upon for clarity and self-containedness.

## Notations

Notations used in this post try to be consistent with "The Transformer Family Version 2.0" (Lilian, 2023)[^3] and latest papers on performance optimizations, which would deviate from (Turner, 2023)[^1] in many places.

Notably, [^1] and [^2] use $D \times N$ matrices to represent the input and output of a transformer, while [^3] uses $L \times D$ matrices. The shape in the latter is more consistent with the conventions in FlashAttention, GPTQ, etc. while the choice of $N$ for token length is more common thus $N \times D$ is adopted in this post.

| Symbol | Shape | Meaning |
| :---: | :---: | :--- |
| $N$ |  | The (token) length of input sequence, $n$ as the index |
| $D$ |  | The size of features of a token / representation, $d$ as the index |
| $M$ |  | The total number of attention layers in the model, $m$ as the index |
| $X^{(0)}$ | $N \times D$ | The input sequence |
| $X^{(m)}$ | $N \times D$ | the output of the $m^{th}$ transformer layer |
| $x^{(m)}_n $ | $1 \times D$ | the (row) vector of features for the $n^{th}$ token of $X^{(m)}$ |

TODO: add a brief table of notations

$$
% NxD matrices in diargams are assumed to be 4x3, i.e. 4 rows and 3 columns
% an example element would be placed on [2, 1], i.e. the 3rd row and the middle column
% a row vector, size 3, with the symbol placed at the center
\def\rvec#1{{\fbox{$ \rule{2em}{0pt} {#1} \rule{2em}{0pt} $}}}
% a wide row vector, size 4, with the symbol placed at the center
\def\wrvec#1{{\fbox{$ \rule{3em}{0pt} {#1} \rule{3em}{0pt} $}}}
% a column vector, size 4, with the symbol placed at the center
\def\cvec#1{\fbox{$ {#1} \rule[-3em]{0pt}{6.5em} $}}
$$

## The input/output of a transformer

A transformer is capable of ingesting "a sequence of tokens" and generating "a representation of the sequence". 

Here, a token refers to a $D$-dimensional vector that represents a small unit of data, e.g. a (sub-)word in a sentence, or an 8x8 patch of a 512x512 image. These units are not fixed and can be chosen based on some domain-specific insight into the underlying structure of the data type.

Representing a token as a vector is commonly called an embedding, and usually is learned to better express the token's features and the relationships among tokens. Each dimension of a embedding vector is called a feature but it's not nessarily a feature in the traditional sense such as an attribute of an object.

Turning data into "a sequence of tokens" is a process called tokenization. After tokenization, the input becomes a sequence of $L$ tokens of dimension $D$, thus can be collected into a $N \times D$  matrix:

$$
\def\Xinput{\begin{bmatrix}
\vdots \cr
\vdots \cr
\rvec{x_n^{(0)}} \cr
\vdots \cr
\end{bmatrix}}
X^{(0)} = \underbrace{\Xinput}_{D \text{ columns (features) }}\left.\vphantom{\cvec{}}\right\\}N \text{ rows (tokens)}
$$

where $X^{(0)}$ denotes the input of the transformer, and $x_n^{(0)}$ is the (row) vector of features for the $n^{th}$ token.

The output, "a representation of the sequence", takes the same form as "a sequence of tokens", and the $n^{th}$ "token" is a $D$-dimensional vector representing the sequence at the location of token $n$.

Various tasks can be achieved by designing an appropriate representation, e.g. auto-regressive prediction of the next $(n+1)^{th}$ token, global classification of the entire sequence (by pooling across the whole representation), sequence-to-sequence or image-to-image prediction problems, etc.

The input/output of a transformer is a powerful and versatile abstraction so that it can be used for mixing data of different modalities (images, texts etc.) and mixed tasks of different types.

For texts, the tokenization process first needs to choose a vocabulary that could cover almost all the words in the language, plus some meta-tokens like `bos_token` representing the beginning of sequence, `eos_token` representing the end of sequence, and `mask_token` for masked language modelling. Then it needs to learn the embedding of each vocabulary element, and it would be clear in a bit that it also needs to learn the embedding of the position of each token in the sequence, called positional embedding, which I presume to be a geometric embedding in general. Latest researches, such as ALiBi (Press et al., 2022 )[^6], suggest that positional information can be encoded in forms other than positional embedding.

(TODO: refer to subword tokenization literatures such as Byte Pair Encoding used in GPT-2, and cover other commonly used tokenization methods such as SentencePiece, as well as various ways to do positional embedding.)

(TODO: explain commonly used tokenizers in popular models, particularly the treatment for non-English languages, but better as an appendix)

## The transformer layer

A transformer is composed of multiple transformer layers. The representation of the input sequence will be produced by iteratively applying a transformer layer

$$ X^{(m)} = \text{transformer-layer}(X^{(m-1)}) $$

where $X^{(m)}$ denotes the output of the $m^{th}$ transformer layer, and recall that $X^{(0)}$ naturally denotes the input of the transformer.

Every transformer layer comprises two stages (or sub-layers):

* Stage 1 refines each feature across the whole sequence, i.e. acts on each column of $X^{(m-1)}$
* Stage 2 refines each token, i.e. acts on each row of $X^{(m-1)}$

By repeatedly applying the transformer layer the representation at
token $n$ and feature $d$ can be shaped by information at token $n'$ and feature $d'$ . This gives the transformer the ability to model long-range dependencies between tokens and features. Such a completeness is a key advantage of the transformer over other architectures but also poses challenges for efficient implementation.

### Stage 1: self-attention over time

Stage 1 produces another $N \times D$ matrix, denoted $Y^{(m)}$. For simplicity, we'll omit the superscripts $(m)$ where it's clear from the context.

#### Attention

The key idea of the attention mechanism is to infer by focusing on a given set of data, hence the name "Attention", as in the famous quote "Attention is all you need" from (Vaswani et al., 2017)[^4], initially introduced by (Bahdanau et al., 2015)[^5] for machine translation.

For visual tasks, the attention mechanism is often used to focus on a small region or some closely related regions of an image. For text tasks, it's used to focus on the relationship between words in one sentence or close context. For multi-modal tasks, it could relate within a modality or between modalities.

The amount of attention is quantified by learned weights and thus the output is usually formed as a weighted average, compactly written as a matrix multiplication:

$$
Y^{(m)} = A^{(m)} X^{(m-1)}
$$

$$
\def\Ydn{\begin{bmatrix}
 & \vdots &  \cr
 & \vdots &  \cr
\cdots & Y_{n, d} & \cdots \cr
 & \vdots & 
\end{bmatrix}}
\def\Xd{\begin{bmatrix}
\cdots & \cvec{X_{:, d}} & \cdots 
\end{bmatrix}}
\def\An{\begin{bmatrix}
\vdots \cr
\vdots \cr
\wrvec{A_{n, :}} \cr
\vdots
\end{bmatrix}}
%------
\Ydn_{N \times D} = \An_{N \times N} \times \Xd_{N \times D}  
$$

Here the weighting is given by a so-called attention matrix $A_{n^{\prime}, n}$ which is of size $ N \times N$ and normalizes over each column $\sum\limits_{n^{\prime}=1}^{N} A_{n^{\prime}, n}=1$, where $n^{\prime}$ denotes a location in the slice $X_{d, :}$, i.e. it points to $X_{d, n^{\prime}}$ and corresponds to the attention quantified by $A_{n^{\prime}, n}$.

$A_{n^{\prime}, n}$ will take a high value for locations in the sequence $n^{\prime}$ which are of high relevance for location $n$.

There're many types of attentions, see ["A Family of Attention Mechanisms"](https://lilianweng.github.io/posts/2018-06-24-attention/#a-family-of-attention-mechanisms) for a summary.

### Stage 2: multi-layer perceptron across features

## References

[^1]: Richard E. Turner, ["An Introduction to Transformers"](https://arxiv.org/abs/2304.10557), arXiv:2304.10557 (2023)

[^2]: Mary Phuong and Marcus Hutter, ["Formal algorithms for transformers"](https://arxiv.org/abs/2207.09238), arXiv:2207.09238 (2022)

[^3]: Lilian Weng, ["The Transformer Family Version 2.0"](https://lilianweng.github.io/posts/2023-01-27-the-transformer-family-v2/), Lil’Log (Jan 2023)

[^4]: Ashish Vaswani, et al. ["Attention is all you need."](http://papers.nips.cc/paper/7181-attention-is-all-you-need.pdf), NIPS 2017.

[^5]: Dzmitry Bahdanau, et al. ["Neural machine translation by jointly learning to align and translate"](https://arxiv.org/abs/1409.0473), ICLR 2015.

[^6]: Press et al. ["Train Short, Test Long: Attention With Linear Biases Enables Input Length Extrapolation."](https://arxiv.org/abs/2108.12409) ICLR 2022.