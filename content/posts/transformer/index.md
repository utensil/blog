---
title: "Transformers: from self-attention to performance optimizations"
publishDate: 2023-05-04T22:00:00+08:00
draft: true
tags:
    - math
    - ML
---

The purpose of this post is to understand what is under the hood and the performance factors involved when fine-tuning and running local Transformer models, keeping multi-modality in mind, with an emphasis on the decoder-only transformers (e.g. GPT series).

To accomplish this, we first present a brief account of the transformer architecture, including its design intuitions and the underlying mathematics, concretized by illustrative diagrams and code snippets. Then we aim to achieve a comprehensive understanding of the widely adopted performance optimizations for the original transformer architecture.

This post was initially inspired by [An Introduction to Transformers (Turner, 2023)](https://arxiv.org/abs/2304.10557) [^1], which provides a mathematically precise, intuitive, and clean description of the transformer architecture. Many other sources are incorporated and improved upon for clarity and self-containedness.

# Notations

Notations used in this post try to be consistent with "The Transformer Family Version 2.0" (Lilian, 2023)[^3] and latest papers on performance optimizations such as FlashAttention, GPTQ, etc. , which deviate from (Turner, 2023)[^1] and (Phuong et al., 2022)[^2] in many places, notably the shape of input/output matrices.

To simplify further, this post will use a simplified version of the concise and powerful "Named Tensor Notation" from (Chiang et al., 2021)[^7] which has many advantages similar to Einops (Rogozhnikov, 2022)[^8]. It's seldom adopted in the literatures but very intuitive and easy to recover the widely adopted notations visually. Essentially, it's a notation trying to avoid concerning the readers with complicated indices and order of them, by naming indices and only specify the indices involved in the operation (e.g. summations,reductions, contractions, reshaping, etc.).

The original "Named Tensor Notation" paper has a dedicated appendix for the transformer architecture, notably, it uses different names for similar concepts:

- the "features"(named `feat`) become
  - `input`/`out` for inputs/outputs
  - `key`/`val` for key/value matrices
  - `layer` in attention layers that covers all heads
  - `hidden` in FFN hidden layers
- "tokens" (the dimension is named `seq` in the view of the whole sequence)
  - sometimes rename to `seq'` to distinguish the input/output

and this causes quite some confusion. In this post, we will consistently use `feat` and `seq`, and let the context to indicate the precise meaning, hinted by subscripts if necessary.

$$
\newcommand{\namedtensorstrut}{\vphantom{fg}} % milder than \mathstrut
\newcommand{\name}[1]{\mathsf{\namedtensorstrut #1}}
\newcommand{\nbin}[2]{\mathbin{\underset{\substack{#1}}{\namedtensorstrut #2}}}
\newcommand{\ndot}[1]{\nbin{#1}{\odot}}
\newcommand{\ncat}[1]{\nbin{#1}{\oplus}}
\newcommand{\nsum}[1]{\sum\limits_{\substack{#1}}}
\newcommand{\nfun}[2]{\mathop{\underset{\substack{#1}}{\namedtensorstrut\mathrm{#2}}}}
\newcommand{\ndef}[2]{\newcommand{#1}{\name{#2}}}
\ndef{\ax}{ax}
\ndef{\dd}{d}
\ndef{\layer}{layer}
\ndef{\seq}{seq}
\ndef{\subseq}{subseq}
\ndef{\key}{key} \ndef{\val}{val}
\ndef{\heads}{heads}
\ndef{\batch}{batch}
\ndef{\inp}{input} \ndef{\hidden}{hidden} \ndef{\out}{out}
\ndef{\height}{height} \ndef{\width}{width} \ndef{\chans}{chans}
\ndef{\kernel}{kernel} \ndef{\kh}{kh} \ndef{\kw}{kw}
\ndef{\vocab}{vocab}
\ndef{\classes}{classes}
\ndef{\state}{state}
\ndef{\emb}{emb}
\ndef{\feat}{feat}
\def\attnbox#1{\colorbox{#1}{\color{#1} O}}
\def\smtxt#1{\text{\small{#1}}}
$$

| Symbol | Type/Shape | Meaning |
| :---: | :---: | :--- |
| $X^{(0)}$ | $\mathbb{R}^{\seq \times \feat}$ | The tokenized input sequence of tokens, length $N$, each token has $D$ features |
| $X^{(m)}$ | $\mathbb{R}^{\seq \times \feat}$ | The output of the $m^{th}$ transformer layer |
| $x^{(m)}_n$ | $\mathbb{R}^{1 \times \feat}$ | The (row) vector of features for the $n^{th}$ token of $X^{(m)}$ |
| $A^{(m)}$ | $\mathbb{R}^{\seq \times \seq}$ | The $N \times N$ attention matrix |

To convey the types/shapes and the definition of operations simontaneously, sometimes we use a syntax like this:

$$ f = op(a, b) \quad \in A \to B \to C $$

where

- $f$ is an operation accepting two operands of type $A$ and $B$ respectively, and returns a value of type $C$
- $f$ is defined as applying some operation $do$ to $a$ and $b$ where $op$ can be arbitrary operation like $a + b$ 
- $∈$ reads "has the type/shape of", the last $→$ reads "maps to" and the ones before simply read "and"

When the types of operands are clear, we could also write the above as:

$$ f = op(a, b) \quad \in C$$

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

# The input/output of a transformer

A transformer is capable of ingesting "a sequence of tokens" and generating "a representation of the sequence". 

Here, a token refers to a $D$-dimensional vector that represents a small unit of data, e.g. a (sub-)word in a sentence, or an 8x8 patch of a 512x512 image. These units are not fixed and can be chosen based on some domain-specific insight into the underlying structure of the data type.

Representing a token as a vector is commonly called an embedding, and usually is learned to better express the token's features and the relationships among tokens. Each dimension of a embedding vector is called a feature but it's not nessarily a feature in the traditional sense such as an attribute of an object.

Turning data into "a sequence of tokens" is a process called tokenization (we'll discuss it in the next section). After tokenization, the input becomes a sequence of $L$ tokens of dimension $D$, thus can be collected into a $N \times D$  matrix:

$$
\def\Xinput{\begin{bmatrix}
\vdots \cr
\vdots \cr
\rvec{x_n^{(0)}} \cr
\vdots \cr
\end{bmatrix}}
X^{(0)} = \underbrace{\Xinput}_{D \text{ columns (features) }}\left.\vphantom{\cvec{}}\right\}N \text{ rows (tokens)}
$$

where $X^{(0)}$ denotes the input of the transformer, and $x_n^{(0)}$ is the (row) vector of features for the $n^{th}$ token.

The output, "a representation of the sequence", takes the same form as "a sequence of tokens", and the $n^{th}$ "token" is a $D$-dimensional vector representing the sequence at the location of token $n$.

Various tasks can be achieved by designing an appropriate training objectives to make use of the representation, e.g. auto-regressive prediction of the next $(n+1)^{th}$ token, global classification of the entire sequence (by pooling across the whole representation), sequence-to-sequence or image-to-image prediction problems, etc.

The input/output of a transformer is a powerful and versatile abstraction so that it can be used for mixing data of different modalities (images, texts etc.) and mixed tasks of different types.

# Tokenization

## Texts

For texts, the tokenization process first needs to choose a vocabulary that could cover almost all the words in the language, plus some meta-tokens like

-  `bos_token` representing the beginning of sequence
-  `eos_token` representing the end of sequence
-  `mask_token` for masked language modelling
-  etc.

Then it needs to learn the embedding of each vocabulary element, and it would be clear in a bit that it also needs to learn the embedding of the position of each token in the sequence, called positional embedding, which I presume to be a geometric embedding in general. Latest researches, such as ALiBi (Press et al., 2022 )[^6], suggest that positional information can be encoded in forms other than positional embedding.

(TODO: expand on the tokenization process, provide formulas for vocabularies, embeddings, and positional embeddings)

(TODO: refer to subword tokenization literatures such as Byte Pair Encoding used in GPT-2, and cover other commonly used tokenization methods such as SentencePiece, as well as various ways to do positional embedding.)

(TODO: explain commonly used tokenizers in popular models, particularly the treatment for non-English languages, but better as an appendix)

(TODO: expand on the tokenization process for images such as in ViT, and for other modalities, better as an appendix or a separate post)

(TODO: latest research suggests that tokenization is not necessary for transformers, this is called "end-to-end" training.)

# The transformer layer

A transformer is composed of multiple transformer layers. The representation of the input sequence will be produced by iteratively applying a transformer layer

$$ X^{(m)} = \text{TransformerLayer}(X^{(m-1)}) $$

where $X^{(m)}$ denotes the output of the $m^{th}$ transformer layer, and recall that $X^{(0)}$ naturally denotes the input of the transformer.

Every transformer layer comprises two stages (or sub-layers):

* Stage 1 refines each feature across the whole sequence
* Stage 2 refines each token across features

By repeatedly applying the transformer layer the representation at
token $n$ and feature $d$ can be shaped by information at token $n'$ and feature $d'$ . This gives the transformer the ability to model long-range dependencies between tokens and features. Such a completeness is a key advantage of the transformer over other architectures but also poses challenges for efficient implementation, especially for long sequences. The performance pros and cons can be succinctly summarized by a quote from (Liu et al., 2018)[^10]:

> The lack of recurrence enables greater within-training-example parallelization, at the cost of quadratic complexity in the input sequence length.

In order to apply transformers to longer sequences, [^10] proposed a decoder-only transformer that

> drops the encoder module (almost reducing model parameters by half for a given hyper-parameter set), combines the input and output sequences into a single "sentence".

For simplity, we'll

- eschew the superscripts $(m)$ denoting the layer index
- use $X, Y$ for the input/output of each stage
  - they all have the same type $\mathbb{R}^{\seq \times \feat}$ i.e. shape $N \times D$
- use dummy symbols $\mathtt{X}, \mathtt{Y}, \dots$ for operands and results when defining operations/functions

## Stage 1: self-attention across the sequence

Stage 1 is based on the self-attention mechanism, which is a special case of the attention mechanism. There're many types of attentions, see ["A Family of Attention Mechanisms"](https://lilianweng.github.io/posts/2018-06-24-attention/#a-family-of-attention-mechanisms) for a summary.

### Attention

The key idea of the attention mechanism is to infer by focusing on a given set of data, hence the name "Attention", as in the famous quote "Attention is all you need" from (Vaswani et al., 2017)[^4]. It's initially introduced by (Bahdanau et al., 2015)[^5] for machine translation where the attention mechanism is used to focus on some related parts of the source sentence when translating a target word.

For visual tasks, the attention mechanism is often used to focus on a small region or some closely related regions of an image. For text tasks, it could be used to focus on the relationship between words in one sentence or close context. For multi-modal tasks, it could relate within a modality or between modalities.

The amount of attention is quantified by learned weights given by a so-called attention matrix $A \in \mathbb{R}^{\seq \times \seq}$.

We can think of the attention weights as probabilities and the input sequence as a set of random variables. The attention weights represent the probability of each token attending to other tokens in the sequence. In this view, the output is the expected value of the input sequence with respect to the attention distribution:

$$
\begin{split}
Y &= \mathbb{E}[Y|X] \cr\cr
  &= \nsum{\seq}{p(Y|X) X}
\end{split}
$$

This is equivalent to taking the weighted average of the input sequence using the attention weights, compactly written as a matrix product:

$$
\begin{split}
Y &= \sum_{\seq} A \odot X \cr\cr
  &= A \underset{\seq}{\odot} X \cr\cr
  &= A X
\end{split}
$$

which is essentially doing the following for each feature $d$:

$$
\def\Ynd{\begin{bmatrix}
 & \vdots &  \cr
 & \vdots &  \cr
\cdots & Y_{\seq, \feat} & \cdots \cr
 & \vdots & 
\end{bmatrix}}
\def\Xod{\begin{bmatrix}
\cdots & \cvec{X_{:, \feat}} & \cdots 
\end{bmatrix}}
\def\Ano{\begin{bmatrix}
\vdots \cr
\vdots \cr
\wrvec{A_{\seq, :}} \cr
\vdots
\end{bmatrix}}
\Ynd_{N \times D} = \Ano_{N \times N} \times \Xod_{N \times D}
$$

Here $A$  normalizes over each column $\sum\limits_{\seq} A =1$.

Specifically, $A_{\seq, \seq_X}$ will take a high value for locations in the output sequence "$\seq$" which are of high relevance for location "$\seq_X$" in the input slice $X_{:, \feat}$.

The following example of attention matrix demonstrates translating from the English sentence "eating a green apple" to the French sentence "manger une pomme verte" assuming only 1 feature for simplicity.

Note that the 3rd token ("pomme", i.e. "apple") in the French sentence pays the greatest attention (marked by a black box) to the 4th token "apple" in the English sentence, and also attend to the 1st token "eating" and the 3rd token "green" in the English sentence (marked by grey boxes) because they're related context to "apple" but almost none to the 2nd token "a" (marked by a lighter grey box).

$$
\def\Ynd{\begin{bmatrix}
\text{manger}  \cr
\text{une}  \cr
\fbox{pomme} \cr
\text{verte}
\end{bmatrix}}
\def\Xod{\begin{bmatrix}
& \fbox{ $ \begin{array}{c}
    \text{eating} \newline \text{a} \newline \text{green} \newline \text{apple}
    \end{array} $ } &
\end{bmatrix}}
\def\Ano{\begin{bmatrix}
\vdots \cr
\vdots \cr
\fbox{ \attnbox{gray} \attnbox{darkgray} \attnbox{gray} \attnbox{black} } \cr
\vdots
\end{bmatrix}}
\Ynd_{4 \times 1} = \Ano_{4 \times 4} \times \Xod_{4 \times 1}
$$

### Self-attention

**Self-attention**, also known as intra-attention, first introduced by (Cheng et al., 2016)[^9], has been shown to be very useful in machine reading, abstractive summarization, image description generation, etc. These motivating tasks all require a decent understanding of the input sequence itself.

It's just a special case of the attention mechanism where the attention matrix corelates different tokens of the same input sequence, that is, to infer for one part of the data using other parts of the observation about the same data.

The attention matrix in the example above becomes something like:

$$
\begin{array}{c}\smtxt{eating} \cr \smtxt{a} \cr \smtxt{green} \cr  \smtxt{apple} \end{array}
\overset{\begin{array}{cccc}\smtxt{eating} & \smtxt{a} & \smtxt{green} &  \smtxt{apple} \end{array}}{
\begin{bmatrix}
\attnbox{black} \attnbox{lightgray} \attnbox{lightgray} \attnbox{gray} \cr
\attnbox{lightgray} \attnbox{black} \attnbox{darkgray} \attnbox{lightgray} \cr
\attnbox{lightgray} \attnbox{lightgray} \attnbox{black} \attnbox{darkgray} \cr 
\attnbox{gray} \attnbox{darkgray} \attnbox{gray} \attnbox{black} 
\end{bmatrix}
}
$$

Note that this matrix is asymmetric:

- syntactically related:
  - "apple" pays unilateral attention to "a" for its quantity
  - "a" pays unilateral attention to "green" for whether it should be "an" instead
- semantically related:
  - "apple" pays more attentions to "green" (which is describing it) than the other way around because "green" is a general color regardless what it's describing

To quantify the amount of attention, we can use the softmax function to give a (naturally normalized) probability distribution that the probability of each token is proportional to proportional to the exponent of a score (which will be calculated later):

$$
A = \nfun{\seq}{softmax}(\nfun{}{score}(X))
$$

where

$$
\nfun{\seq}{softmax} \mathtt{X} =\frac{\exp \mathtt{X}}{\nsum{\seq} \exp \mathtt{X}}
$$

A simple way of calculating the score from the input would be to measure the similarity between two tokens by their features.

Mathematically, it can be given by the dot product between the features of those two tokens and then use a softmax function to handle the normalization i.e.

$$
\nfun{}{score}(X) = \nfun{\seq}{softmax}(X \ndot{\feat } X)
$$



However, this naïve approach handles solely the content similarity between tokens, treats all features of the tokens equally, which hasn't taken into account how the tokens are organized and related in the sequence, and their in-context semantics (e.g. the word "crane" could mean a machine or an animal depending on the context).

An improvement is to perform the same operation on a linear transformation of the sequence, $U \ndot{\seq} X$, so that 

$$
\nfun{}{score}(X) = (U \ndot{\seq} X) \ndot{\feat} ( U \ndot{\seq} X ) 
$$

The linear transformation will selectively project out some of the features in the input sequence and focus on other features, thereby the attention matrix will have a better chance capturing the relations between tokens in the context of the given sequence.

However, this attention matrix is symmetric unlike the asymmetric version seen above, which is essential for expressing asymmetric relations. The solution is to use two different linear transformations to compute the similarity, i.e.

$$
\nfun{}{score}(X) = Q \ndot{\feat} K = (W_q \ndot{\seq} X) \ndot{\feat} ( W_k \ndot{\seq} X )
$$

Here we start using notations closer to (Vaswani et al., 2017)[^4]. $Q$ and $K$ are called **query matrix** and **key matrix**, generated by the linear transformations $W_q$ and $W_k$, which are the learnable **w**eights for them, respectively.

In a similar spirit(TODO: why?), we will also need a third linear transformation $W_v$ applied to the $X$ in $Y= A X$ to generate the **value matrix** $V$.

The concepts query/key/value originate from retrieval systems. Using these concepts, the self-attention mechanism treats the input sequence as a database. Thus the query focuses on the question or the instruction embeded in the input sequence, the key is an index of the context embeded in the input sequence, and the value is what the self-attention mechanism retrieve by correlating the query and the key.

To summarize, the self-attention mechanism now becomes:

$$
Y = \nfun{}{Attention}(X) = \nfun{}{Attention}(Q, K, V) = A \ndot{\seq} V = \left( 
  \nfun{}{softmax} ( Q \ndot{\feat} K ) \right) \ndot{\seq} V  
 $$

To improve numerical stability, we can divide the dot product by the square root of the dimension of the feature space, denoted $|\feat|$, i.e.

$$
\nfun{}{Attention}(Q, K, V) = \left( 
  \nfun{}{softmax} \frac{ Q \ndot{\feat} K }{\sqrt{ |\feat| }} \right) \ndot{\seq} V 
$$

To address the need to apply a mask to ensure attention is only applied to valid keys (e.g. for causal language models, we need to masking out the future words in the sequence to prevent the model from cheating by looking ahead at the words it is supposed to predict), we can add a mask matrix $M$ to the dot product, i.e.

$$
\nfun{}{Attention}(Q, K, V, M) = \left( 
  \nfun{}{softmax} \left( \frac{ Q \ndot{\feat} K }{\sqrt{ |\feat| }} + M \right)
\right) \ndot{\seq} V 
$$

where

$$ M_{ij} = \begin{cases}
  0 & \text{if $i \leq j$} \cr
  -\infty & \text{otherwise}
\end{cases} \quad \in \mathbb{R}^{\seq_i \times \seq_j} $$

### Multi-head self-attention (MHSA)

In retrospect, the self-attention mechanism looks at the same data with 2 different perspectives (i.e. focuses) for 2 different purposes (query and context), build a holistic perspectives on these 2 perspectives,  then have a final look at the data. How it allocates the attention in the perspectives is determined by the similarity between selected features. And how to select the features is what is learned during training.

It's immediately obvious that the ways to select features is limited, there is only one attention matrix, a global attention. It would be useful for pairs of tokens to be similar in some features and different in others, so the self-attention attention matrix can capture multiple drastically different relations between tokens.

A typical example is understanding jokes. Jokes make use of puns, irony, misdirection, satire etc. They all invovle multiple distinct relations between tokens, or reinterpretation of the same tokens.

Another consideration is performance bottleneck. A global attention matrix for a long sequence such as pages of documents is computationally expensive yet sparse in nature thus obviously unoptimized. It would be more efficient to have multiple attention matrices, each of which is local and dense. Then corelate the relavant attention matrices to capture long-range relations.

Based on these ideas, Multi-head self-attention (MHSA) applies $H$ sets of self-attention in parallel (termed $H$ heads) and then linearly projects the results to $Y$.

This is summarized in (Vaswani et al., 2017)[^4] as:

> Multi-head attention allows the model to jointly attend to information from different representation subspaces at different positions. With a single attention head, averaging inhibits this.
> 
> Not only do individual attention heads clearly learn to perform different tasks, many appear to exhibit behavior related to the syntactic and semantic structure of the sentences.

Or put it in other words, MHSA saves the orginal self-attnetion mechanism from being "one-track minded" i.e. overly focused on one way and unable to consider other perspectives or ideas. Particularly, this one way is doomed to be mediocre, and with the diversity from MHSA, the output is more likely to excel.

If we lift $Q$/$K$/$V \in \mathbb{R}^{\seq \times \feat_{Q/K/V}}$ to $\mathbb{R}^{\heads \times \seq \times \feat_{Q/K/V}}$, shrinking $|\feat_{Q/K/V}|$ to $|\feat| / |\heads|$, then MHSA can be defined as:

$$ \nfun{}{MHSA}(X) = W_o \ndot{\heads \cr \feat_V} \nfun{}{Attention}(Q, K, V) $$

where $W_o \in \mathbb{R}^{\heads \times \feat_V \times \feat}$ is for linearly projecting the results of the heads to the output $Y$.

The computational cost of MHSA is usually dominated by the matrix multiplication involving the attention matrix and is
therefore $\mathcal{O}(H D N^2)$.

## Stage 2: position-wise FFN across features

Stage 1 of the transformer layer transformed tokens to representations using the self-attention mechanism, but we'll keep calling the representations "tokens" which is also interchangeable with "locations" in this post.

Stage 2 of the transformer layer operates across features, refining each token using a non-linear transform.

To do this, we simply apply a fully connected feed-forward network(FFN) to the vector of features for each token in the sequence, which consists of two linear transformations with an activation in between:

$$
Y = \nfun{}{FFN}(X) = (\sigma(X \ndot{\feat} W_1 + b_1)) \ndot{\feat} W_2 + b_2
$$

where the activation function $\sigma$ is typically the rectified linear unit (ReLU) but can be any non-linear function:

$$
\sigma(\mathtt{X}) = \operatorname{ReLU}(\mathtt{X}) = \max(0, \mathtt{X})
$$

Note that the parameters of the FFN are the same for each token, i.e. it is applied to each position separately and identically (hence termed "Position-wise Feed-Forward Networks" in (Vaswani et al., 2017)[^4]).

The FFN used typically have hidden-layers with dimension equal to the number of features D (or larger). The computational cost of this stage is therefore $\mathcal{O}(N D^2)$.

## Wire stages up

To have a more stable model that trains more easily, we need to employ two techniques before producing the final output:

- **Residual connection** (denoted $\oplus$): it's simply adding the input to the output of each stage: $$Y = X + \operatorname{Stage}(X)$$
- **Layer normalization** (denoted $\operatorname{LayerNorm}$ or $\operatorname{LN}$): it could be applied
  - post-residual[^4]: $$Y = \operatorname{LN_post}(X + \operatorname{Stage}(X))$$
  - pre-stage (dorminant in practice): $$Y = X + \operatorname{Stage}(\operatorname{LN_pre}(X))$$
  - both: $$
  Y = \operatorname{LN_post}(X + \operatorname{Stage}(\operatorname{LN_pre}(X)))
  $$

where $\operatorname{Stage}$ is $\operatorname{MHSA}$ and $\operatorname{FFN}$ for the 1st and 2nd stages, respectively.

The formulas become a bit too verbose with the parentheses, we can rewrite the last formula using a pipe operator $\triangleright$:

$$ Y = X \triangleright \operatorname{LN_pre} \triangleright \operatorname{Stage} \triangleright (X + \cdot) \triangleright \operatorname{LN_post} $$

Now we are ready to recover a architecture diagram of the transformer layer like the ones in literatures (but using only $\operatorname{LN_pre}$):

<!-- {{< figure src="./transformer_layer.drawio.svg" class="center" >}} -->

{{< figure src="./transformer_layer.pikchr.svg" class="center" >}}

### Residual connection

The use of residual connections make initialization simple, have a sensible inductive bias towards simple functions, and stabilize learning (Szegedy et al., 2017)[^11].

With residual connections, each stage doesn't directly learn the weights $\theta$ of a large transformation $\operatorname{Trans}_\theta$ like below:

$$
Y = \operatorname{Trans}_{\theta}\left(X\right)
$$

Instead it learns the difference between the transformed result and the identity function, called the residual $\operatorname{Res}_{\theta}$. This way each stage applies a mild non-linear transformation to the input:

$$
Y = X + \operatorname{Res}_{\theta}\left(X\right)
$$

Over many layers, these mild non-linear transformations compose to form large transformations.

### Layer normalization

**LayerNorm** (Ba et al., 2016)[^12] acts on each feature dimension independently, removing the mean and dividing by the standard deviation.

Pre-LN addresses the gradient vanishing/exploding problem(as nonlinearities are repeatedly applied through stages and layers), and is dorminant in practice. But pre-LN could result in representation collapse that can be addressed by post-LN, see [a discussion](https://twitter.com/rasbt/status/1655575611979489282) for details.

$$
\def\mttX{\mathtt{X}}
\nfun{}{LayerNorm}(\mttX; \gamma, \beta) = \gamma \odot \frac{\mttX - \nfun{\feat}{mean}(\mttX)}{\sqrt{\nfun{\feat}{var}(\mttX) + \epsilon}} + \beta
$$

where

$$
\nfun{\feat}{mean} \mttX = \frac{1}{|\feat|} \nsum{\feat}{\mttX}
$$

$$
\nfun{\feat}{var} \mttX  = \frac{1}{|\feat|} \nsum{\feat}{(\mttX - \nfun{\feat}{mean} \mttX)^2}
$$

$ \epsilon $ is a small constant added to the variance to avoid division by zero, and $\gamma$ and $\beta$ are learned parameters that scale and shift the normalized value.

<!-- {{< cite "turner2023introduction" >}}{{< cite "phuong2022formal" >}}{{< cite "weng2023transformer" >}}{{< cite "vaswani2017attention" >}} -->

# References

[^1]: Richard E. Turner, ["An Introduction to Transformers"](https://arxiv.org/abs/2304.10557), arXiv:2304.10557 (2023)

[^2]: Mary Phuong and Marcus Hutter, ["Formal algorithms for transformers"](https://arxiv.org/abs/2207.09238), arXiv:2207.09238 (2022)

[^3]: Lilian Weng, ["The Transformer Family Version 2.0"](https://lilianweng.github.io/posts/2023-01-27-the-transformer-family-v2/), Lil’Log (Jan 2023)

[^4]: Ashish Vaswani, et al. ["Attention is all you need."](http://papers.nips.cc/paper/7181-attention-is-all-you-need.pdf), NIPS 2017.

[^5]: Dzmitry Bahdanau, et al. ["Neural machine translation by jointly learning to align and translate"](https://arxiv.org/abs/1409.0473), ICLR 2015.

[^6]: Press et al. ["Train Short, Test Long: Attention With Linear Biases Enables Input Length Extrapolation."](https://arxiv.org/abs/2108.12409) ICLR 2022.

[^7]: Chiang et al. ["Named Tensor Notation"](https://arxiv.org/abs/2102.13196), arXiv:2102.13196 (2021)

[^8]: Alex Rogozhnikov, ["Einops: Clear and Reliable Tensor Manipulations with Einstein-like Notation"](https://openreview.net/forum?id=oapKSVM2bcj), ICLR 2022. 

[^9]: Jianpeng Cheng et al. ["Long short-term memory-networks for machine reading"](https://arxiv.org/abs/1601.06733), arXiv:1601.06733 EMNLP 2016.

[^10]: Peter Liu et al. ["Generating wikipedia by summarizing long sequences"](https://arxiv.org/abs/1801.10198), arXiv:1801.10198, 2018.

[^11]: Christian Szegedy et al., ["Inception-v4, inception-resnet and the impact of residual connections on learning"](https://arxiv.org/abs/1602.07261), AAAI 2017. 

[^12]: Ba et al., [Layer normalization](https://arxiv.org/abs/1607.06450), arXiv:1607.06450, 2016.

<!-- # References

{{< bibliography cited >}}

{{< bibliography >}} -->