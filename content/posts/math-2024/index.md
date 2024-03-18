---
title: "My math interests in 2024"
date: 2024-03-16T22:00+08:00
draft: true
---

I wish this post to be a continuously updated list of my math interests in 2024 with proper citations to literatures, as I keep wandering in the math wonderland and I don't want to be lost in it without breadcrumbs.

Some interests that have older origins will gradually moved to corresponding posts for earlier years.

I also hope certain interests will be developed into research projects, and leaving only a brief summary and a link here.

Each interest should have one or few central questions, and one or few references to literatures.

## Formalization

This part of interests is about small-scale formalization of mathematical concepts and theorems, for learning and potential PRs to Lean's Mathlib. Each should focus on one reference which is well organized and convenient to be converted into a blueprint.

### The Matrix Cookbook (November 15, 2012)

This book {{< cite "petersen2008matrix" >}} covers many useful results about matrices, and Eric Wieser's project [lean-matrix-cookbook](https://github.com/eric-wieser/lean-matrix-cookbook) aims to give one-liner proofs (with reference to the counter part in Mathlib) to all of them.

The project is far from complete and it would be great to claim a small portion of interested results and contribute to it. I also wish to figure out the GA counterpart of the same portion.

Previous interests about matrices rise from Steven De Keninck's work on GALM {{< cite "de2019geometric" >}}, since the paper I have been interested in GA approaches that has practical advantages over traditional matrix-based methods. Notably the paper also discussed the link between degenerate Clifford algebras and dual numbers / automatic differentiation.

TODO: decide which results are interesting and feasible to be formalized for me.

### Group Algebra

> In a sense, group algebras are the source of all you need to know about representation theory.

The primary reference is {{< cite "james2001representations" >}} for understanding FG-module, Group algebra, the presentation of groups, Schur indices etc. We also need to check {{< cite "lux2010representations" >}} for its introduction to [GAP](https://www.gap-system.org/), and we should pay close attention to the progress of [GAP-LEAN](https://github.com/opencompl/lean-gap).

The related Zulip thread is [here](https://leanprover.zulipchat.com/#narrow/stream/217875-Is-there-code-for-X.3F/topic/Group.20algebra.20over.20finite.20groups), and I have explorations and experiments in Lean [here](https://github.com/utensil/lean-playground/blob/master/lean4/examples/FiniteGroup.lean).

## Generalized Clifford Algebra and related mathematical branches

### DKP Algebra

Duffin-Kemmer-Petiau Algebra is $$\frac{T(V)}{I(v\otimes w\otimes v - g(v,w)v)}$$ in the same way that Clifford Algebra is $$\frac{T(V)}{I(v\otimes v - g(v,v))}.$$ 

See {{< cite "fernandes2022clifford">}} which embeds DKP Algebra in Clifford Algebra with projectors.

## Applied mathematics

### Topology

I wish to render some pictures in {{< cite "francis1987topological" >}} in GA, inspired by Steven De Keninck's notebooks, e.g. TODO.

### Knots

See {{< cite "manturov2018knot" >}} and [the tracking issue](https://github.com/utensil/utensil.github.io/issues/229).

### Origami

See {{< cite "hull2020origametry" >}} and [the tracking issue](https://github.com/utensil/utensil.github.io/issues/133).

### Dynamical Systems: Bifurcation Theory

The preferred reference for me is {{< cite "izhikevich2007dynamical" >}} for its applications in neuroscience and various excellent diagrams. But this is not a mathematically rigorous treatment of bifurcation theory.

## TODOs

Incorporating the following interests into this post:

- [Threads of thought in recent years (in Chinese)](https://www.douban.com/doulist/156001812/)
- Interests logged [here](https://github.com/utensil/utensil.github.io/issues)

# References

{{< references >}}

