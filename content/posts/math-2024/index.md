---
title: "My math interests in 2024"
publishDate: 2024-03-16T22:00:00+08:00
draft: true
tags:
    - math
---

I wish this post to be a continuously updated list of my math interests in 2024 with proper citations to literatures, as I keep wandering in the math wonderland and I don't want to be lost in it without breadcrumbs.

Some interests that have older origins will gradually moved to corresponding posts for earlier years.

I also hope certain interests will be developed into research projects, and leaving only a brief summary and a link here.

Each interest should have one or few central questions, and one or few references to literatures.

## Formalization

This part of interests is about small-scale formalization of mathematical concepts and theorems, for learning and potential PRs to Lean's Mathlib. Each should focus on one reference which is well organized and convenient to be converted into a blueprint.

### Spin groups

The PR to Mathlib [#9111](https://github.com/leanprover-community/mathlib4/pull/9111) about Spin groups is ready to merge, but there are 2 open questions:

- what more lemmas about Spin groups are interesting to mathematians?
- what more should be formalized to formalize Versors and what’s in Section "The contents of a geometric algebra" in {{< cite "chisolm2012geometric" >}} , e.g. r-blades, r-vectors?

For the former, I should take a closer look at {{< cite "figueroa2010spin" >}} and maybe {{< cite "suarez2019expository" >}}, {{< cite "reynoso2023probing" >}}.

For the latter, see the [Z-filteration in lean-ga](https://github.com/pygae/lean-ga/blob/master/src/geometric_algebra/from_mathlib/versors.lean) and [the prototype](https://github.com/eric-wieser/lftcm2023-clifford_algebra/).

I also wish to include some latest results presented in {{< cite "ruhe2023clifford" >}}, with supplements from {{< cite "brehmer2023geometric" >}}, in which some of the results are proven in {{< cite "roelfs2023graded" >}}.

See also discussions in the [lean-ga blueprint](https://utensil.github.io/lean-ga/blueprint/sect0007.html).

### The Matrix Cookbook (November 15, 2012)

This book {{< cite "petersen2008matrix" >}} covers many useful results about matrices, and Eric Wieser's project [lean-matrix-cookbook](https://github.com/eric-wieser/lean-matrix-cookbook) aims to give one-liner proofs (with reference to the counter part in Mathlib) to all of them.

The project is far from complete and it would be great to claim a small portion of interested results and contribute to it. I also wish to figure out the GA counterpart of the same portion.

Previous interests about matrices rise from Steven De Keninck's work on GALM {{< cite "de2019geometric" >}}, since the paper I have been interested in GA approaches that has practical advantages over traditional matrix-based methods. Notably the paper also discussed the link between degenerate Clifford algebras and dual numbers / automatic differentiation. A more recent inspiration might be his new work [LookMaNoMatrices](https://github.com/enkimute/LookMaNoMatrices).

TODO: decide which results are interesting and feasible to be formalized for me.

### Group Algebra

> In a sense, group algebras are the source of all you need to know about representation theory.

The primary reference is {{< cite "james2001representations" >}} for understanding FG-module, Group algebra, the presentation of groups, Clifford theory (which is the standard method of constructing representations and characters of semi-direct products, see {{< cite "woit2017quantum" >}}, and "3.6 Clifford theory" in {{< cite "lux2010representations" >}}), Schur indices etc. We also need to check {{< cite "lux2010representations" >}} for its introduction to [GAP](https://www.gap-system.org/), and we should pay close attention to the progress of [GAP-LEAN](https://github.com/opencompl/lean-gap). {{< cite "sims1994computation" >}} might also be interesting in a similar manner as {{< cite "lux2010representations" >}} but with emphasis on the presentation of groups.

See also [group algebra on nlab](https://ncatlab.org/nlab/show/group+algebra), particularly that "A group algebra is in particular a Hopf algebra and a $G$-graded algebra."

The related Zulip thread is [here](https://leanprover.zulipchat.com/#narrow/stream/217875-Is-there-code-for-X.3F/topic/Group.20algebra.20over.20finite.20groups), and I have preliminary explorations and experiments in Lean [here](https://github.com/utensil/lean-playground/blob/master/lean4/examples/FiniteGroup.lean).

This interest originates from reading Robert A. Wilson's work {{<cite "wilson2024discrete">}}. The ultimate goal is to understand the group algebra of the binary tetrahedral group ($Q_8 \rtimes Z_3$), then the three-dimensional complex reflection group ($G_{27} \rtimes Q_8 \rtimes Z_3$), a.k.a. the triple cover of the Hessian group, which can be interpreted as a finite analogue of the complete gauge group $U(1) \times SU(2) \times SU(3)$.

## Generalized Clifford Algebra and related mathematical branches

A [Clifford algebra](https://en.wikipedia.org/wiki/Clifford_algebra) is a $Z_2$-[graded algebra](https://en.wikipedia.org/wiki/Graded_algebra), and a [Filtered algebra](https://en.wikipedia.org/wiki/Filtered_algebra), the associated graded algebra is the [exterior algebra](https://en.wikipedia.org/wiki/Exterior_algebra).

It may be thought of as quantizations (cf. quantum group) of the exterior algebra, in the same way that the Weyl algebra is a quantization of the symmetric algebra. [Specifically](https://ncatlab.org/nlab/show/Clifford+algebra#AsQuantizedExteriorAlgebra), for $V$ an inner product space, the symbol map constitutes an isomorphism of the underlying super vector spaces of the Clifford algebra with the exterior algebra on  $V$, and one may understand the Clifford algebra as the quantization Grassmann algebra induced from the inner product regarded as an odd [symplectic form](https://ncatlab.org/nlab/show/symplectic+form).

Weyl algebras and Clifford algebras admit a further structure of a [*-algebra](https://en.wikipedia.org/wiki/*-algebra), and can be unified as even and odd terms of a [superalgebra](https://en.wikipedia.org/wiki/Superalgebra), as discussed in [CCR and CAR algebras](https://en.wikipedia.org/wiki/CCR_and_CAR_algebras).

A [Clifford module](https://en.wikipedia.org/wiki/Clifford_module) is a representation of a Clifford algebra.

A [Generalized Clifford algebra (GCA)](https://en.wikipedia.org/wiki/Generalized_Clifford_algebra) can also refer to associative algebras that are constructed using forms of higher degree instead of quadratic forms, e.g.

> For $q_1, q_2, \ldots, q_m \in \mathbb{k}^*$, the generalized Clifford algebra $C^{(n)}\left(q_1, q_2, \ldots, q_m\right)$ is a unital associative algebra generated by $e_1, e_2, \ldots, e_m$ subject to the relations
> $$ e_i^n=q_i \mathbf{1}, \quad e_i e_j=\omega e_j e_i, \quad \forall j \lt i . $$
>
> It is easy to see that $C^{(n)}\left(q_1, q_2, \ldots, q_m\right)$ is $\mathbb{Z}_n$-graded where the degree of $e_i$ is $\overline{1}$, the generator of $\mathbb{Z}_n$. {{< cite "cheng2019new" >}}

In {{< cite "cheng2019new" >}}, note also that "Clifford algebras are weak [Hopf algebras](https://en.wikipedia.org/wiki/Hopf_algebra) in some symmetric tensor categories." while "generalized Clifford algebras are weak Hopf algebras in some suitable braided linear categories of graded vector spaces." as well as that "the Clifford process is a powerful technique to construct larger dimensional Clifford algebras from known ones."

Clifford algebras can be obtained by twisting of group algebras {{< cite "albuquerque2002clifford" >}}, where twisted group algebras are studied in {{< cite "conlon1964twisted" >}}, {{< cite "edwards1969twisted" >}}, {{< cite "edwards1969twisted2" >}}.

There exists isomorphisms between certain Clifford algebras and NDAs (Normed Division Algebras) over $\mathbb{R}$.

Variants of Clifford algebras whose generators are idempotent or nilpotent can be considered. Zeon algebras ("nil-Clifford algebras") have proven to be useful in enumeration problems on graphs where certain configurations are forbidden, such as in the enumeration of matchings and self-avoiding walks. The idempotent property of the generators of idem-Clifford algebras can be used to avoid redundant information when enumerating certain graph and hypergraph structures. See {{< cite "ewing2022zeon" >}}.

It's also closely related to universal enveloping algebra (see {{< cite "figueroa2010spin" >}} and "The universal enveloping algebra of a Lie algebra is the analogue of the usual group algebra of a group." from [group algebra on nlab](https://ncatlab.org/nlab/show/group+algebra#RelationToUniversalEnvelopingAlgebra)).

Great discussions about the limitations and generalizations of Clifford algebras can be found in John C. Baez's {{< cite "baez2002octonions" >}}. Particularly, note [Cayley-Dickson construction](https://en.wikipedia.org/wiki/Cayley-Dickson_construction), Bott periodicity, matrix algebra, triality, and $\mathbb{R}$ as a real commutative associative nicely normed ∗-algebra. Also see Anthony Lasenby's work on the embedding of octonions in the Clifford geometric algebra for space-time STA ( $\mathop{\mathcal{C}\ell}(1, 3)$ ) {{< cite "lasenby2024some">}}.

Note also Kingdon algebras: alternative Clifford-like algebras over vector spaces equipped with a symmetric bilinear form {{< cite "depies2024octonions" >}}.

### Categorified Clifford Algebra

A categorical view of Clifford Algebra is discussed in {{< cite "figueroa2010spin" >}}.

A Clifford Algebra can be [categorified](https://golem.ph.utexas.edu/category/2007/10/categorified_clifford_algebra.html): "An Clifford algebra over a vector space is defined to be the Koszul dual to an abelian fully weak Lie-algebra" where "Fully weak Lie-algebras are Koszul dual to differential graded Clifford algebras." See also [Higher Clifford Algebras](https://golem.ph.utexas.edu/category/2007/10/higher_clifford_algebras.html).

### Sheaves of Clifford Algebras

Sheaves of Clifford Algebras are studied in {{< cite "yizengaw2015clifford" >}} and its references. See also {{< cite "schapira2023introduction" >}}, an elementary introduction to {{< cite "kashiwara2006categories" >}}, which presents categories, homological algebra and sheaves in a systematic and exhaustive manner.

### DKP Algebra

Duffin-Kemmer-Petiau Algebra is $$\frac{T(V)}{I(v\otimes w\otimes v - g(v,w)v)}$$ in the same way that Clifford Algebra is $$\frac{T(V)}{I(v\otimes v - g(v,v))}.$$ 

See {{< cite "fernandes2022clifford">}} which embeds DKP Algebra in Clifford Algebra with projectors.

## Applied mathematics

### Topology

I wish to render some pictures in {{< cite "francis1987topological" >}} with [TikZ](https://github.com/kisonecat/tikzjax), GLSL shader, and by GA with [ganja.js](https://github.com/enkimute/ganja.js) & [GAmphetamine](https://enki.ws/GAM/src/GAmphetamine.js) or their Lean version, inspired by Steven De Keninck's notebooks, e.g. [torus](https://observablehq.com/@enkimute/torus-circle-circle), [orbit 1](https://observablehq.com/@enkimute/orbit-of-the-day), [orbit 2](https://observablehq.com/@enkimute/animated-orbits), [origami](https://enki.ws/ganja.js/examples/coffeeshop.html#pga3d_origami), [skinning](https://enki.ws/ganja.js/examples/coffeeshop.html#pga3d_skinning), [slicing](https://enki.ws/ganja.js/examples/coffeeshop.html#pga3d_slicing) etc.

### Knots

See {{< cite "manturov2018knot" >}} and [the tracking issue](https://github.com/utensil/utensil.github.io/issues/229).

### Origami

See {{< cite "hull2020origametry" >}} and [the tracking issue](https://github.com/utensil/utensil.github.io/issues/133).

### Dynamical Systems: Bifurcation Theory

The preferred reference for me is {{< cite "izhikevich2007dynamical" >}} for its applications in neuroscience and various excellent diagrams. But it's not a mathematically rigorous treatment of bifurcation theory.

### Sheaves

My first impression of sheaves is that they are useful to local-to-global applications "which ask for global solutions to problems whose hypotheses are local".

Roughly speaking, a sheaf requires some gluing conditions (axioms "Locality" and "Gluing") so that local data can be collated compatibly into a global algebraic structure that varies continuously over local covering domains ("sections" of sheaves).

To do so, a sheaf in general, as defined in the category-theoretical language, needs

- a topological space (or a site in general), denoted $X$ (or $\mathcal{C}$ for a site)
- a category, sometimes denoted $\mathcal{D}$, meaning "data category", whose objects are algebraic structures and morphisms are structure-preserving maps

and builds (gluing conditions) on a $\mathcal{D}$-valued presheaf over $X$ (or $\mathcal{C}$), denoted $\mathcal{F}$ (as its French name is "faisceau"), which is essentially a  contravariant functor $\mathcal{F}: \mathcal{C}^{op} \to \mathcal{D}$ but a [concept with an attitude](https://ncatlab.org/nlab/show/concept+with+an+attitude#presheaves_and_copresheaves), and its morphisms are restriction maps between open sets in $X$ (or between objects that satisfy the pretopology $\mathcal{J}$ in $C$, where $\mathcal{J}$ is the pretopology on $\operatorname{Open}(X)$, which specifies when a covering family of open sets exists).

Its latest application to deep learning, Thomas Gebhart's thesis {{< cite "gebhart2023sheaf" >}} sees a sheaf over a topological space as a data structure "which defines rules for associating data to a space so that local agreements in data assignment align with a coherent global representation", thus a generalization of both:

- relational learning, which aims to "combine symbolic, potentially hand-engineered prior knowledge with the tabula rasa representational flexibility of deep learning to achieve a synthetic model family which can be defined with respect to symbolic knowledge priors about the data domain"
- geometric deep learning, which "provides a group-theoretic approach to reasoning about and encoding domain-symmetry invariance or equivariance within machine learning models",

"providing a mathematical framework for characterizing the interplay between the topological information embedded within a domain and the representations of data learned by machine learning models".

My prior interest in geometric deep learning, particularly group-equivariant neural networks, and my believe in symbolism, are the background of my interest in sheaf representation learning.

Notably, this thesis treats the discrete case of sheaves, a cellular sheaf, whose

- topological space is a cell complex, which is "a topological generalization of a graph, with set inclusion and intersection given by the incidence relationships among cells in the complex", thus "admitting a computable, linear-algebraic representation".
- data category is $\mathtt{FVect}$, the category of finite-dimensional vector spaces over a field $\mathbb{F}$, which is a common choice for the data category in machine learning applications, a model-free approach with massive parameter space, flexible representational capacity, but inherits fundamental limitations, e.g. data inefficiency, generalization failure, and interpretability issues. 

For more details, see also Thomas Gebhart's talk [Sheaves for AI: Graph Representation Learning through Sheaf Theory](https://cats.for.ai/assets/slides/sheaves_for_AI.pdf).

<!-- has the potential to learn sheaf representations of data, which is essentially assigning observed data to a space in a way that's 

globally consistent with the constraints imposed by the topology of the application domain .

a richer but still tractable representation that is an algebraic structure richer than a vector space commonly used in ML, to sampled data, which is in the form of components of a category (e.g. a category of a data structure like a Graph).  -->

Its application to physics has the potential to formulate differential geometry in a more general setting, without assuming the existence of a locally Euclidean space as manifold did. It's believe that this approach can overcome some difficulties in Quantum field theory even Quantum gravity, because locally there might be no concept of a metric space at all {{< cite "mallios2015differential" >}}.

## TODOs

Incorporating the following interests into this post:

- [Threads of thought in recent years (in Chinese)](https://www.douban.com/doulist/156001812/)
- Interests logged [here](https://github.com/utensil/utensil.github.io/issues)

# References

{{< bibliography cited >}}

