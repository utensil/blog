---
title: "Zeon Algebra"
publishDate: 2024-03-23T10:00:00+08:00
draft: true
---

I have just borrowed [*Clifford Algebras and Zeons: Geometry to Combinatorics and Beyond*](https://www.amazon.com/Clifford-Algebras-Zeons-Geometry-Combinatorics/dp/9811202575) {{< cite "staples2020clifford" >}} from the library. This post should briefly walk through the contents of the book, highlight some key concepts, and provide further readings for each chapter of the book.

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
  - Graph theory
    - hypercubes {{< cite "west2001introduction;wilson1979introduction" >}}
      - The $n$-dimensional cube, or hypercube $\mathcal{Q}_n$, is the graph whose vertices are in one-to-one correspondence with the $n$-tuples of zeros and ones and whose edges are the pairs of $n$-tuples that differ in exactly one position.
      - The structure of the hypercube allows one to construct a random walk on the hypercube by "flipping" a randomly selected digit from 0 to 1 or vice versa.
      - Random walks on Clifford algebras have also been studied as random walks on directed hypercubes {{< cite "schott2008random" >}}. By considering certain generalizations of hypercubes, combinatorial properties can be obtained for tackling a variety of problems in graph theory and combinatorics {{< cite "schott2011nilpotent;staples2005clifford;staples2008new" >}}.

## Part II: Geometric Algebra

1 9 67 80

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

See {{< cite "ablamowicz2004lectures;bayliss2019geometric;lounesto2001clifford;porteous1995clifford" >}}

# References

{{< bibliography cited >}}

