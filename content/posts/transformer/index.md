---
title: "Transformer: From attention to performance efficiency"
date: 2023-05-04T22:00+08:00
draft: true
---

This post draws inspiration from [An Introduction to Transformers (Turner, 2023)](https://arxiv.org/abs/2304.10557) [^1], which provides a mathematically precise, intuitive, and clean description of the transformer architecture.

The purpose of this post is to delve into the insights, mathematical treatments, and implementation considerations of the transformer architecture. By providing just enough description, math, code, and diagrams, this post also aims to facilitate a comprehensive understanding of various performance optimizations to the original transformer architecture.

Initial draft would look very similar to (Turner, 2023)[^1] and gradually (Phuong et al., 2022)[^2] and other sources will be incorporated.

## Notations

TODO

## The input/output of a transformer

A transformer will ingest "a sequence of tokens" and return "a representation of
the sequence".

The input, "a sequence of tokens", is a generic representation, many different types of data can be “tokenised”, e.g. a sequence of words embedded into vectors
or patches of images embedded into vectors. 

Namely, it's a sequence of $N$ tokens of dimension $D$, thus can be collected into a $D \times N$ matrix:

$$
X = \underbrace{\begin{bmatrix} \cdots & \cdots & & {\fbox{$X_n \rule[-3em]{0pt}{6em}$}} &  \cdots \end{bmatrix}}_{N \\, \text{columns (tokens)}}\left.\vphantom{\rule[-3em]{0pt}{6em}}\right\\}D \text{ rows (features)}
$$

where $X_n$ is the (column) vector of features for the $n^{th}$ token.

The output, "a representation of the sequence", takes the same form as "a sequence of tokens", and the $n^{th}$ "token" is a vector of $D$ features representing the sequence at the location of token $n$.

Various tasks can be achieved by designing an appropriate representation, e.g. auto-regressive prediction of the next (n+1)th token, global classification of the entire sequence (by pooling across the whole representation), sequence-to-sequence or image-to-image prediction problems, etc.

The input/output of a transformer is a powerful and versatile abstraction so that it can be used for mixing data of different modalities (images, texts etc.) and mixed tasks of different types.

## The transformer block

The transformer is composed of multiple transformer blocks, which are similar to layers in other deep learning models. The representation of the input sequence will be produced by iteratively applying a transformer block

$$ X^{(m)} = \text{transformer-block}(X^{(m-1)}) $$

where $X^{(m)}$ denotes the ouput of the $m^{th}$ transformer block, and $X^{(0)}$ denotes the input of the transformer.

Every transformer block comprises two stages:

* Stage 1 acts horizontally across rows of $X^{(m-1)}$, refines each feature independently
* Stage 2 acts vertically across columns of $X^{(m-1)}$, refines the features representing each token

By repeatedly applying the transformer block the representation at
token $n$ and feature $d$ can be shaped by information at token $n'$ and feature $d'$ .

### Stage 1: self-attention over time


### Stage 2: multi-layer perceptron across featur

## References

[^1]: Richard E. Turner, ["An Introduction to Transformers"](https://arxiv.org/abs/2304.10557), arXiv:2304.10557 (2023)

[^2]: Mary Phuong and Marcus Hutter, ["Formal algorithms for transformers"](https://arxiv.org/abs/2207.09238), arXiv:2207.09238 (2022)
