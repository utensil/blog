---
title: "Notes on Zeon Algebra"
publishDate: 2024-03-23T10:00:00+08:00
draft: true
tags:
    - math
---

I have just borrowed [*Clifford Algebras and Zeons: Geometry to Combinatorics and Beyond*](https://www.amazon.com/Clifford-Algebras-Zeons-Geometry-Combinatorics/dp/9811202575) {{< cite "staples2020clifford" >}} from the library. This post should briefly walk through the contents of the book, highlight some key concepts, and provide further readings for each chapter of the book. For the complete and updated research work by George Stacey Staples, see [his home page](https://www.siue.edu/~sstaple/index_files/research.html).

This note, however, is not intended to be a comprehensive review of the book. Instead, it is a personal note emphasizing the foundational part of the book, by viewing Zeon algebra as an extension and an application of Clifford algebra, to gain insights into the combinatorial properties hidden in Clifford algebra.

## Part I: The Essentials

- Algebra
  - Linear algebra
    - Gram-Schmidt orthogonalization
      - (1) First, set $\mathbf{u}_1:=\mathbf{v}_1$.
      - (2) For each $\ell=2, \ldots, k$, set $$ \mathbf{u}\_{\ell}:=\mathbf{v}\_{\ell}-\sum_{j=1}^{\ell-1} \frac{\left\langle\mathbf{v}\_{\ell}, \mathbf{u}\_j\right\rangle}{\left\|\mathbf{u}\_j\right\|^2} \mathbf{u}\_j . $$
      - (3) The collection $S^{\prime}=\left\\{\mathbf{u}_1, \ldots, \mathbf{u}_k\right\\}$ now satisfies $\operatorname{span}(S)=\operatorname{span}\left(S^{\prime}\right)$. If unit vectors are required, normalize the collection $S^{\prime}$ by dividing each element by its norm.
  - Semigroup representation
    - the theorem for determine the number of irreducible representations of a semigroup {{< cite "staples2020clifford;serre1977linear;clifford1961algebraic;rhodes1991elementary" >}}
      - Let $G_1, \ldots, G_m$ be a choice of exactly one maximal subgroup from each regular $\mathfrak{J}$-class of $S$. Then, letting $k_i$ denote the number of conjugacy classes of $G_i$, the number of irreducible representations of $S$ is $\sum\limits_{i=1}^m k_i$
- Combinatorics
  - Combinatorics associated with polynomials {{< cite "cohen1978basic;tucker1994applied" >}}
  - Graph theory {{< cite "west2001introduction;wilson1979introduction" >}}
    - A $k$-walk $\left\\{v\_0, \ldots, v\_k\right\\}$ in a graph $G$ is a sequence of vertices in $G$ with initial vertex $v_0$ and terminal vertex $v_k$ such that there exists an edge $\left(v\_j, v\_{j+1}\right) \in E$ for each $0 \leq j \leq k-1$.
    - Powers of the adjacency matrix of a graph provide a simple and convenient tool for counting walks ni finite graphs: Let $G$ be a graph on $n$ vertices with associated adjacency matrix $A$. Then for any positive integer $k$, the $(i, j)$ th entry of $A^k$ (i.e. the $k$-th power of $A$) is the number of $k$-walks $i \rightarrow j$. In particular, the entries along the main diagonal of $A^k$ are the numbers of closed $k$-walks in $G$.
    - hypercubes
      - The $n$-dimensional cube, or hypercube $\mathcal{Q}_n$, is the graph whose vertices are in one-to-one correspondence with the $n$-tuples of zeros and ones and whose edges are the pairs of $n$-tuples that differ in exactly one position.
      - The structure of the hypercube allows one to construct a random walk on the hypercube by "flipping" a randomly selected digit from 0 to 1 or vice versa.
      - Random walks on Clifford algebras have also been studied as random walks on directed hypercubes {{< cite "schott2008random" >}}. By considering certain generalizations of hypercubes, combinatorial properties can be obtained for tackling a variety of problems in graph theory and combinatorics {{< cite "schott2011nilpotent;staples2005clifford;staples2008new" >}}.

## Part II: Geometric Algebra

See also {{< cite "ablamowicz2004lectures;bayliss2019geometric;lounesto2001clifford;porteous1995clifford" >}}.

- Geometry of the Complex Plane
- Quaternions
  - $\mathfrak{Q}$: a non-Albelian group of unit quaternions
  - $\mathbb{H} := \mathbb{R} \mathfrak{Q} = \\{ x_0 + x_1 \mathbf{i} + x_2 \mathbf{j} + x_3 \mathbf{k} : x_0, x_1, x_2, x_3 \in \mathbb{R} \\}$, i.e. the group algerba of $\mathfrak{Q}$ over $\mathbb{R}$
  - Let $\mathbf{u}$ be a unit column vector in $\mathbb{R}^n$. The operator $\ket{\mathbf{u}}\bra{\mathbf{u}} = \mathbf{u} \mathbf{u}^{\dagger}$ is a rank-one orthogonal projection onto the subspace spanned by $\mathbf{u}$.
- Euclidean Clifford Algebras
  - Gram-Schmidt orthogonalization Revisited
    - Suppose $S=\left\\{\mathbf{v}_1, \ldots, \mathbf{v}_k\right\\}$ is a linearly independent collection in $\mathbb{R}^n$. Using properties of the geometric product, Gram-Schmidt orthogonalization is accomplished in $\mathcal{C} \ell_n$ as follows.
      - (1) First, set $\mathbf{u}_1:=\mathbf{v}_1$.
      - (2) For each $\ell=2, \ldots, k$, set $ \mathbf{u}\_{\ell}:=\mathbf{v}\_{\ell}-\sum\_{j=1}^{\ell-1}\left(\frac{\mathbf{v}\_{\ell} \mathbf{u}\_j+\mathbf{u}\_j \mathbf{v}\_{\ell}}{2 \mathbf{u}\_j{ }^2}\right) \mathbf{u}\_j $
      - (3) The collection $S^{\prime}=\left\\{\mathbf{u}_1, \ldots, \mathbf{u}_k\right\\}$ now satisfies $\operatorname{span}(S)=\operatorname{span}\left(S^{\prime}\right)$. If unit vectors are required, normalize the collection $S^{\prime}$ by dividing each element by its norm.
  - Let $\sharp \mathfrak{u}$ denote the maximum grade among nonzero terms in the canonical basis blade expansion of $\mathfrak{u}$. The grade of $\mathfrak{u}$ is $\sharp \mathfrak{u}+1$.
  - Decompositions in the Clifford Lipschitz Group
      - Let $\mathcal{C} \ell\_n{ }^\*$ denote the multiplicative group of invertible Clifford elements. In particular, $$ \mathcal{C} \ell\_n{ }^\*=\left\\{u \in \mathcal{C} \ell\_n: u \tilde{u} \in \mathbb{R}^\*\right\\} . $$
      - The inverse of $u \in \mathcal{C} \ell_n$ is then seen to be $u^{-1}=\frac{\tilde{u}}{u \tilde{u}}$.
      - The Clifford Lipschitz group, $\Gamma_n$, is the subgroup of $\mathcal{C} \ell_n{ }^\*$ whose elements $u \in \Gamma_n$ satisfy
        - $u \in \mathcal{C} \ell_n^{+} \cup \mathcal{C} \ell_n^{-}$
        - for all $\mathbf{x} \in V, u \mathbf{x} \bar{u} \in V$.
      - Two important subgroups of the Clifford Lipschitz group are the pin and spin groups.
        - The pin group $\operatorname{Pin}(n)=\left\\{u \in \mathcal{C} \ell\_n^{+} \cup \mathcal{C} \ell\_n^{-}: u \tilde{u}= \pm 1\right\\}$ is a double covering of $O(n)$.
        - The spin group $\operatorname{Spin}(n)=\left\\{u \in \mathcal{C} \ell\_n^{+} \cup \mathcal{C} \ell\_n^{-}: u \tilde{u}=1\right\\}$ is a double covering of $S O(n)$.
      - The conformal orthogonal group $\mathrm{CO}(n)$ is defined as the direct product of dilations and orthogonal transformations on $\mathbb{R}^n$.
      - An element $\mathfrak{u} \in \mathcal{C} \ell_n$ is said to be decomposable if $\mathfrak{u} = \mathbf{v}\_1 \cdots \mathbf{v}\_k$ for some linearly independent collection of vectors $\left\\{\mathbf{v}\_1, \ldots, \mathbf{v}\_k\right\\}$ in $\mathcal{C} \ell\_n$. Equivalently, $\mathfrak{u}$ is decomposable if and only if it satisfies the following conditions:
        - (1) $\mathfrak{u} \in \mathcal{C} \ell_n^{+} \cup \mathcal{C} \ell_n^{-}$
        - (2) For all $\mathrm{x} \in V, \mathfrak{u x} \overline{\mathfrak{u}} \in V$.
      - In fact, the decomposable elements of $\mathcal{C} \ell_n$ are precisely the elements of the Clifford Lipschitz group, $\Gamma_n$. Further, one quickly sees that decomposable elements $\mathfrak{u} \in \mathcal{C} \ell_n^{+} \cup \mathcal{C} \ell_n^{-}$satisfying $\mathfrak{u} \tilde{\mathfrak{u}}=\alpha \neq 0$ provide a double covering of the conformal orthogonal group $\mathrm{CO}(n)$.
  - vector decomposition in definite signatures {{< cite "aragon2009reflections" >}}
- Clifford Algebras of Arbitrary Signature
  - For positive integer $n$, let $V$ be an $n$-dimensional vector space over $\mathbb{R}$ with orthonormal basis $\beta=\left\\{\mathbf{e}\_i\right\\}\_{1 \leq i \leq n}$. Suppose $p$ and $q$ are nonnegative integers such that $n=p+q$. Let $\mathcal{B}$ be the multiplicative group generated by $\{ \pm 1\} \cup \beta$ with multiplication defined by the following: $$\mathbf{e}_i \mathbf{e}_j= \begin{cases}-\mathbf{e}_j \mathbf{e}_i & \text { if } i \neq j \cr 1 & \text { if } 1 \leq i=j \leq p \cr -1 & \text { if } p+1 \leq i=j \leq p+q\end{cases}$$
  - Given $I \subseteq\{1,2, \ldots, n\}$, define the multi-index notation $\mathbf{e}_I$ to denote the canonically ordered product $$ \mathbf{e}\_I=\prod\_{i \in I} \mathbf{e}\_i . $$
  - The set $\beta$ with the operation of multiplication as defined above generates a nonabelian group $\mathcal{B}$ of order $2^{n+1}$.
  - Elements of $\mathcal{B}$ will be referred to as blades. Considering binary representations of subsets of the $n$-set, it becomes apparent that the Cayley graph of $\mathcal{B} /\{ \pm 1\}$ is isomorphic to the $n$-dimensional hypercube $\mathcal{Q}_n$.
  - Given positive integer $n$ and nonnegative integers $p, q$ such that $n=p+q$, the Clifford algebra of signature $(p, q)$ is the group algebra of $\mathcal{B}$ over $\mathbb{R}$, where $\mathcal{B}$ is defined as above.
  - $\mathcal{B}$ can be written as a disjoint union of the form $\mathcal{B}=\bigcup\_{k=0}^n \mathcal{B}\_k$, where $\mathcal{B}\_k=\left\\{ \pm \mathbf{e}\_I:|I|=k\right\\}$. In light of this, $\mathcal{C} \ell_{p, q}$ is a graded algebra; i.e., it has the canonical decomposition $$
    \mathcal{C} \ell\_{p, q}=\mathbb{R} \oplus \mathbb{R} \mathcal{B}\_1 \oplus \cdots \oplus \mathbb{R} \mathcal{B}\_{p+q} $$
  - Given $u \in \mathcal{C} \ell_{p, q}$, define the grade-k part of $u$ by $$ \langle u\rangle_k:=\sum_{\{I:|I|=k\}} u\_I \mathbf{e}\_I $$
  - The even subalgebra of $\mathcal{C} \ell_{p, q}$ is defined by $$ \mathcal{C} \ell_{p, q}^{+}:=\bigoplus_{k=0}^{\lfloor n / 2\rfloor} \mathbb{R} \mathcal{B}_{2 k}=\mathbb{R} \mathcal{B}^{+} $$ where $\mathcal{B}^{+}:=\left\\{ \pm \mathbf{e}\_I:|I| \text{is even} \right\\}$
  - The geometric product of arbitrary blades $\mathbf{e}\_I, \mathbf{e}\_J \in \mathcal{C} \ell\_{p, q}$ is given by $$ \mathbf{e}\_I \mathbf{e}\_J=(-1)^{\phi(I, J)+|I \cap J \cap Q|} \mathbf{e}\_{I \triangle J} $$
where $I \triangle J=(I \cup J) \backslash(I \cap J), Q=\\{p+1, \ldots, p+q\\}$, and $\phi(I, J): 2^{[n]} \times 2^{[n]}$ : $\mathbb{Z}\_{\geq 0}$ is defined by $$ \phi(I, J)=\sum_{j \in J}|\{i \in I: i>j\}|$$
- Decompositions in $CO_Q(V)$
    - Beginning with a finite-dimensional vector space $V$ equipped with a nondegenerate quadratic form $Q$, we consider the decompositions of particular elements of the Clifford Lipschitz group $\Gamma$ in the Clifford algebra $\mathcal{C} \ell_Q(V)$. These elements represent the conformal orthogonal group $\mathrm{CO}_Q(V)$, defined as the direct product of the orthogonal group $O_Q(V)$ with dilations.
    - The collection of all $Q$-orthogonal transformations on $V$ forms a group called the orthogonal group of $Q$, denoted $\mathrm{O}_Q(V)$. Specifically, $T \in \mathrm{O}_Q(V)$ if and only if for every $\mathbf{x} \in V, Q(T(\mathbf{x}))=Q(\mathbf{x})$. The conformal orthogonal group, denoted $\mathrm{CO}_Q(V)$, is the direct product of the orthogonal group with the group of dilations. More specifically, $\tau \in \mathrm{CO}_Q(V)$ if and only if for every $\mathbf{x} \in V$, there exists a scalar $\lambda$ such that $Q(\tau(\mathbf{x}))=\lambda^2 Q(\mathbf{x})$.
    - Given a decomposable k-element $\mathfrak{u}=\mathbf{w}\_1 \cdots \mathbf{w}\_k \in$ $\mathcal{C} \ell\_Q(V)$, let $n=\operatorname{dim} V$ and define $\varphi\_{\mathfrak{u}} \in \mathrm{O}\_Q(V)$ by $$ \varphi\_{\mathfrak{u}}(\mathbf{v})=\mathfrak{u} \mathbf{v} \widehat{\mathfrak{u}^{-1}} .$$ Then $\varphi\_{\mathfrak{u}}$ has an eigenspace $\mathcal{E}$ of dimension $n-k$ with corresponding eigenvalue 1 .
    - Let $\mathbf{x} \in V$ be arbitrary. Then $\mathbf{x}-\varphi_{\mathfrak{u}}(\mathbf{x}) \in V_{\mathfrak{u}}$. In other words, the operator $\pi_u:=\mathbb{I}-\varphi_{\mathfrak{u}}$ is a projection into the subspace determined by $\mathfrak{u}$.
    - This observation alows one to define a $\mathfrak{u}$-subspace projection by $\pi_{\mathfrak{u}}(\mathbf{x}):=\left(\mathbf{x}-\mathfrak{\mathfrak{u} \mathbf{x}} \widehat{\mathfrak{u}^{-1}}\right)$
- From Geometry to Combinatorics
  - Hypercubes play an important role in Clifford algebras and their "combinatorially interesting" subalgebras. By constructing subalgebras with different multiplicative properties, different types of combinatorial computations can be performed：
    - The Clifford algebra $\mathcal{C} \ell_{p, q, r}$. Generated by anticommutative generators $\left\\{\mathbf{e}\_{\{i\}}: 1 \leq i \leq n=p+q+r\right\\}$ and unit scalar 1 satisfying $$ \mathbf{e}_{\{i\}}{ }^2= \begin{cases}1 & 1 \leq i \leq p, \cr -1 & p+1 \leq i \leq p+q, \cr 0 & p+q+1 \leq i \leq p+q+r .\end{cases} $$
    - The "sym-Clifford" algebra $\mathcal{C} \ell_{p, q, r}{ }^{\text {sym}}$. Generated by pairwise commutative $\left\\{\varsigma\_{\{i\}}: 1 \leq i \leq p+q+r\right\\}$ along with unit scalar 1 satisfying the squaring rules above.
    - The $n$-particle zeon algebra $\mathcal{C} \ell_n{ }^{\text {nil }}$. Generated by pairwise commutative $\left\\{\zeta\_{\{i\}}: 1 \leq i \leq n\right\\}$ along with unit scalar 1 subject to $\zeta_{\{i\}}{ }^2=0$ for $i=1, \ldots, n$.
    - The "idem-Clifford" algebra $\mathcal{C} \ell_n{ }^{\text {idem}}$. This algebra is generated by pairwise-commutative idempotent generators $\left\\{\varepsilon\_{\{i\}}: 1 \leq i \leq n\right\\}$ along with unit scalar 1 . In particular, $\varepsilon\_{\{i\}}{ }^2=\varepsilon\_{\{i\}}$ for $i=1, \ldots, n$.
  - Each of the algebras above can be viewed as the quotient of a group algebra or a semigroup algebra.
  - In this chapter, we will focus on the particular groups underlying the Clifford algebras $\mathcal{C} \ell_{p, q}$ and the semigroups underlying $\mathcal{C} \ell_n{ }^{\text {nil }}$. The Cayley graphs of these groups and semigroups are generalizations of hypercubes, and irreducible representations of the algebras can then be characterized by considering irreducible representations of the (semi)groups. 
    - A representation of a given group, $G$, is a homomorphism $\rho: G \rightarrow \mathrm{GL}_n(\mathbb{C})$
    - The degree of this representation is $n$, and the representation space is the space $\mathbb{C}^n$ on which the elements of $\mathrm{GL}_n(\mathbb{C})$ act.
    - Given a representation $\rho(g)$ and a subspace $W$ of $\mathbb{C}^n$, we say $W$ is $G$-invariant if $\rho(g) W \subseteq W$ for every $g \in G$. If the only invariant spaces are ${0}$ and $V$, the representation is said to be irreducible.
    - The character of a representation, $\chi: G \rightarrow \mathbb{C}$, is defined by $\chi(g)=\operatorname{tr}(\rho(\mathrm{g}))$.
    - A representation $\rho$ with character $\chi$ is irreducible if and only if $\chi$ satisfies $$ (\chi \mid \chi)=\frac{1}{|G|} \sum_{g \in G} \chi(g) \overline{\chi(g)}=1 . $$ {{< cite "serre1977linear" >}}
    - Two representations $\rho$ and $r$ of a group $G$ are said to be isomorphic if there exists an invertible mapping $f: \mathbb{C}^n \rightarrow \mathbb{C}^n$ such that $$ f \circ \rho=r \circ f . $$
    - For the the classification of representations of irreducible complex representations of Clifford subalgebras, see {{< cite "cassiday2015representations" >}}.
  - Let $B=\left\\{\mathbf{e}\_1, \ldots, \mathbf{e}\_n\right\\}$, and let $p$ and $q$ be nonnegative integers such that $p+q=n$. Let $\mathcal{B}\_{p, q}$ be the multiplicative group generated by $B$ along with the elements $\left\\{\mathbf{e}\_{\varnothing}, \mathbf{e}\_\alpha\right\\}$, subject to the following generating relations:
    - for all $x \in B \cup\left\\{\mathbf{e}\_{\varnothing}, \mathbf{e}\_\alpha\right\\}$, $$ \begin{gathered} \mathbf{e}\_{\varnothing} x=x \mathbf{e}\_{\varnothing}=x \cr \mathbf{e}\_\alpha x=x \mathbf{e}\_\alpha \cr \mathbf{e}\_{\varnothing}{ }^2=\mathbf{e}\_\alpha{ }^2=\mathbf{e}\_{\varnothing} \end{gathered} $$
    - and $$ \mathbf{e}\_i \mathbf{e}\_j= \begin{cases}\mathbf{e}\_\alpha \mathbf{e}\_j \mathbf{e}\_i & \text { if } i \neq j \cr \mathbf{e}\_{\varnothing} & \text { if } i=j \leq p \cr \mathbf{e}\_\alpha & \text { if } p+1 \leq i=j \leq n .\end{cases} $$
  - The group $\mathcal{B}_{p, q}$ is referred to herein as the blade group of signature $(p, q)$.
  - Let $\mathfrak{G}\_n$ denote the null blade semigroup defined as the semigroup generated by the collection $G=\left\\{\gamma\_i: 1 \leq i \leq n\right\\}$ along with $\left\\{\gamma\_{\varnothing}, \gamma\_\alpha, 0\_\gamma\right\\}$ satisfying the following generating relations:
    - for all $x \in G \cup$ $\left\\{\gamma\_{\varnothing}, \gamma\_\alpha, 0\_\gamma\right\\}$ $$
\begin{gathered}
\gamma\_{\varnothing} x=x \gamma\_{\varnothing}=x, \cr
\gamma\_\alpha x=x \gamma\_\alpha, \cr
0\_\gamma x=x 0\_\gamma=0\_\gamma, \cr
\gamma\_{\varnothing}{ }^2=\gamma\_\alpha{ }^2=\gamma\_{\varnothing},
\end{gathered}
$$
    - and $$
\gamma\_i \gamma\_j= \begin{cases}0\_\gamma & \text { if and only if } i=j \cr \gamma\_\alpha \gamma\_j \gamma\_i & i \neq j .\end{cases}
$$
  - Let $\mathfrak{Z}\_n$ denote the zeon semigroup defined as the semigroup generated by the collection $C=\left\\{\zeta\_i: 1 \leq i \leq n\right\\}$ along with $\left\\{\zeta\_{\varnothing}, 0\_\zeta\right\\}$ satisfying the following generating relations:
    - for all $x \in C \cup\left\\{\zeta\_{\varnothing}, 0\_\zeta\right\\}$, $$
\begin{gathered}
\zeta\_{\varnothing} x=x \zeta\_{\varnothing}=x, \cr
0\_\zeta x=x 0\_\zeta=0\_\zeta, \cr
\zeta\_{\varnothing}{ }^2=0\_\zeta,
\end{gathered}
$$
    - and $$
\zeta\_i \zeta\_j= \begin{cases}0\_\zeta & \text { if and only if } i=j, \cr \zeta\_j \zeta\_i & i \neq j .\end{cases}
$$
  - The zeon semigroup is of particular interest, as its associated semigroup algebra is canonically isomorphic to the zeon algebra.
  - The Clifford algebra $\mathcal{C} \ell_{p, q}(p+q>1)$ is canonically isomorphic to the blade group quotient algebra $\mathbb{R} \mathcal{B}\_{p, q} /\left\langle\mathbf{e}\_\alpha+\mathbf{e}\_{\varnothing}\right\rangle$. Considering the degree-1 representations, $\rho\_J\left(\mathbf{e}\_{\varnothing}\right)=\rho\_J\left(\mathbf{e}\_\alpha\right)=1$ for all $J \in 2^{[p+q]}$. It then becomes clear that passing to the quotient has no effect on the number of irreducible representations. On the other hand, the higher-dimensional irreducible representations satisfy $\tilde{\tau}\left(\mathbf{e}\_{\varnothing}+\mathbf{e}\_\alpha\right)=$ 0 a priori, so that representations of the group algebra are precisely the representations of the quotient algebra.
  - The Grassmann exterior algebra, $\wedge \mathbb{R}^n$, is canonically isomorphic to the null blade semigroup algebra $\mathcal{B} \ell\_{\wedge n}=\mathbb{R} \mathfrak{G}\_n /\left\langle 0\_\gamma, \gamma\_\alpha+\gamma_{\varnothing}\right\rangle$. This algebra is isomorphic to the algebra of fermion creation (or annihilation) operators.
  - The $n$-particle zeon algebra $\mathcal{C} \ell\_n{ }^{\text {nil}}$ is canonically isomorphic to the Abelian null blade semigroup algebra $\mathbb{R} \mathfrak{Z}\_n /\left\langle 0\_\zeta\right\rangle$. This algebra is isomorphic to an algebra of commuting lowering or raising (annihilation or creation) operators.
  - Groups and Semigroups
    - $\mathcal{B}_{p, q}$
      - Generator Commutation: $\mathbf{e}\_i \mathbf{e}\_j=\mathbf{e}\_\alpha \mathbf{e}\_j \mathbf{e}\_i$
      - Generator Squares: $\{\underbrace{\mathbf{e}\_{\varnothing}, \ldots, \mathbf{e}\_{\varnothing}}\_p, \underbrace{\mathbf{e}\_\alpha, \ldots, \mathbf{e}\_\alpha}\_q\}$
    - $\mathfrak{G}_n$
      - Generator Commutation: $\gamma_i \gamma_j=\gamma_\alpha \gamma_j \gamma_i$
      - Generator Squares: $\gamma_i{ }^2=0_\gamma, i=1, \ldots, n$
    - $\mathfrak{Z}_n$
      - Generator Commutation: Abelian
      - Generator Squares: $\zeta_i{ }^2=0_\zeta, i=1, \ldots, n$
  - For the rest of the details worked out in this chapter, see the book itself, no other references can be found except the earlier book {{< cite "schott2012operator" >}}.

## PART III: Algebraic Combinatorics & Zeons

- Algebraic and Combinatorial Properties of Zeons
  - The $n$-particle zeon algebra, denoted $\mathcal{C} \ell_n{ }^{\text {nil }}$, is defined as the real abelian algebra generated by the collection $\left\\{\zeta\_i\right\\}(1 \leq i \leq n)$ along with the scalar $1=\zeta\_\varnothing$ subject to the following multiplication rules: $$
\begin{gathered}
\zeta_i \zeta_j=\zeta_j \zeta_i \text { for } i \neq j, \text { and } \cr
\zeta_i{ }^2=0 \text { for } 1 \leq i \leq n .
\end{gathered}
$$
    - In recent years, combinatorial properties and applications of zeons have been studied in numerous works, many of which are summarized in the monograph {{< cite "schott2012operator" >}}.
    - See also Chapter 3 *Zeon algebras* in [the guide](http://www.siue.edu/%7Esstaple/index_files/Mathematica/CliffMathGuide2018.pdf) to the author's [CLIFFMATH package](http://www.siue.edu/%7Esstaple/index_files/Mathematica/CliffMath2018.m) for Mathematica, available as a [Mathematica Notebook](http://www.siue.edu/%7Esstaple/index_files/Mathematica/CliffMath2018.nb).
- Zeon Polynomials
  - See Section *Zeon polynomials* of Chapter 3 *Zeon algebras* in the guide
- Norms and Inequalities in Zeon Algebras
  - See Section *Zeon Norms* of Chapter 3 *Zeon algebras* in the guide
- Zeon Matrices
  - See Section *Zeon Matrices* of Chapter 3 *Zeon algebras* in the guide
- Zeon Functions and Factorizations
  - See Section *Zeon Function* and *Elementary factorizations* of Chapter 3 *Zeon algebras* in the guide
- Zeon Differential Calculus
  - See Section *Derivitives and antiderivatives of Zeon functions* of Chapter 3 *Zeon algebras* in the guide
  - See also the dedicated paper {{< cite "staples2019differential" >}}
- Graph Enumeration Problems
  - Examples of graph enumeration problems include counting structures like paths, trails, cycles, circuits, spanning trees, matchings, cliques, and independent sets in a given graph. The null-square property of zeon generators makes them especially convenient for symbolic computations associated with enumeration problems on finite graphs.
  - Given a graph $G=(V, E)$ on $n=|V|$ vertices, let $\mathcal{C} \ell_V{ }^{\text {nil }}$ be the zeon algebra of dimension $2^n$ whose generators are in one-to-one correspondence with the vertices of $G$. The nilpotent adjacency matrix associated with $G$ is defined by $$
\Phi\_{i j}=\left\\{\begin{array}{l}
\zeta\_{v\_j}, \text { if }\left\\{v\_i, v\_j\right\\} \in E(G) \cr
0, \text { otherwise. }
\end{array}\right.
$$
    - Most of contents in this chapter can be found in {{< cite "staples2008new;schott2011nilpotent" >}} except *15.2 Matchings, Cliques, and Independent Sets* (which can be found in {{< cite "ewing2022zeon" >}} ) and *15.3 Minimal Path Algorithms* (which can be found in {{< cite "schott2017generalized" >}}).
- Graph Colorings and Chromatic Structures
    - The extension of nilpotent matrix methods to graph colorings allows one to count heterochromatic and monochromatic self-avoiding walks in colored graphs. Further, the zeon-algebraic formalism allows one to quickly verify whether a given graph coloring is proper, and it provides a convenient framework for implementing greedy coloring algorithms.
    - See the dedicated paper {{< cite "staples2017zeons" >}}
- Boolean Satisfiability
  - The Boolean satisfiability problem, or SAT, is the problem of determining whether the variables of a given Boolean formula can be consistently replaced by true or false in such a way that the formula evaluates to be true.
  - See the dedicated paper {{< cite "davis2019zeon" >}}

## PART IV: Induced Operators

- Induced Operators and Kravchuk Polynomials
  - The term induced operator will generally refer to an operator on a Clifford algebra $\mathcal{C} \ell_Q(V)$ obtained from an operator on the underlying vector space $V$ spanned by the algebra's generators.
  - The term reduced operator will generally refer to an operator on the paravector space $V_*:=\mathbb{R} \oplus V$ obtained from an operator on the Clifford algebra.
  - A deduced operator will be an operator on $V$ obtained by restricting an operator on the full algebra, provided the operator on $V$ also induces the operator on the full algebra.
  - Kravchuk polynomials appear as traces of conjugation operators in Clifford algebras and in Clifford Berezin integrals of Clifford polynomials.
  - The three-term recurrence relation for the Kravchuk polynomials of order $n$ is as follows. Define $K_0(x ; n):=1$ and $K_1(x ; n):=x$. For $\ell \geq 2$, the $\ell$ th Kravchuk polynomial is given by $$
K_{\ell}(x ; n):=x K_{\ell-1}(x ; n)+(\ell-1)(n-\ell+2) K_{\ell-2}(x ; n) .
$$
  - An explicit formula for the $n$th Kravchuk polynomial is given by$$
K_{\ell}(x, n):=\sum_{i=0}^n(-1)^i\left(\begin{array}{c}
x \cr
i
\end{array}\right)\left(\begin{array}{c}
n-x \cr
\ell-i
\end{array}\right)
$$
  - The $n$th Kravchuk matrix, $\mathfrak{K}\_n$, is the $(n+1) \times(n+1)$ matrix defined via the Kravchuk polynomial generating function according to $$
(1+x)^{n-\jmath}(1-x)^j=\sum\_{i=0}^n x^i\left\langle e\_i\left|\mathfrak{K}\_n\right| e\_j\right\rangle,
$$ with $\left\langle e\_i\left|\mathfrak{K}\_n\right| e\_j\right\rangle=K\_i(j ; n)$, the $i$ th Kravchuk polynomial evaluated at $j$.
  - Kravchuk Classification of Clifford Algebras
    - Fixing canonical unit vector basis $\left\\{\mathbf{e}_j: 0 \leq j \leq n\right\\}$ for $\mathbb{R}^{n+1}$, define the vector $\mathfrak{h}\_n \in \mathbb{R}^{n+1}$ by $$
  \mathfrak{h}\_n=\sum\_{j=0}^n(-1)^{j(j-1) / 2} \mathbf{e}\_j .
  $$
    - Clifford algebras $\mathcal{C} \ell_{p, q}$ and $\mathcal{C} \ell_{p^{\prime}, q^{\prime}}$ are isomorphic if and only if $\left\langle\mathfrak{h}\_n\left|\mathfrak{K}\_n\right| \mathbf{e}\_q-\mathbf{e}\_{q^{\prime}}\right\rangle=0$, where $n=p+q=p^{\prime}+q^{\prime}$.
  - See the dedicated paper {{< cite "staples2015kravchuk" >}}
- Graph-Induced Operators
  - Operators are induced on fermion and zeon algebras by the action of adjacency matrices and combinatorial Laplacians on the vector spaces spanned by the graph's vertices. Properties of the algebras automatically give information about the graph's spanning trees and vertex coverings by cycles \& matchings. Combining the properties of operators induced on fermions and zeons gives a fermion-zeon convolution that recovers the number of Hamiltonian cycles in an arbitrary graph.
  - See the dedicated paper {{< cite "staples2017hamiltonian" >}}
- Solutions and Hints to Selected Exercises

# References

{{< bibliography cited >}}

