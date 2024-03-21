---
title: "Studying group algebras with GAP"
publishDate: 2024-03-21T10:00:00+08:00
draft: true
---

This post studies group algebras with [GAP](https://github.com/gap-system/gap), focusing on a few interested groups. See [*My math interests in 2024: Group Algebra*](../math-2024/#group-algebra) for context.

It's helpful to read [GAP Manual](https://docs.gap-system.org/doc/ref/chap0_mj.html) and [SO questions](https://math.stackexchange.com/search?q=%5Bgroup-theory%5D+GAP+group+algebra) before using GAP.

## Installation

I'm using Mac, so I ran the following commands to install and start GAP:

```bash
brew install wget autoconf gmp readline
wget https://github.com/gap-system/gap/releases/download/v4.13.0/gap-4.13.0.tar.gz
tar xzvf gap-4.13.0.tar.gz
cd gap-4.13.0
./autogen.sh
./configure
make -j4 V=1 all
make check
make install
which gap
gap -l .
```

Then I can see something like:

```
 ┌───────┐   GAP 4.13.0 of 2024-03-15
 │  GAP  │   https://www.gap-system.org
 └───────┘   Architecture: aarch64-apple-darwin23-default64-kv9
 Configuration:  gmp 6.3.0, GASMAN, readline
 Loading the library and packages ...
 Packages:   AClib 1.3.2, Alnuth 3.2.1, AtlasRep 2.1.8, AutPGrp 1.11, CRISP 1.4.6, Cryst 4.1.27, CrystCat 1.1.10, CTblLib 1.3.9, 
             FactInt 1.6.3, FGA 1.5.0, GAPDoc 1.6.7, IRREDSOL 1.4.4, LAGUNA 3.9.6, Polenta 1.3.10, Polycyclic 2.16, PrimGrp 3.4.4, 
             RadiRoot 2.9, ResClasses 4.7.3, SmallGrp 1.5.3, Sophus 1.27, SpinSym 1.5.2, StandardFF 1.0, TomLib 1.2.11, TransGrp 3.6.5, 
             utils 0.85
 Try '??help' for help. See also '?copyright', '?cite' and '?authors'
gap>
```

which is the GAP console.

Great, let's run some GAP code! Note that the code can be copy-pasted into a GAP console, and `gap>` will be omitted by GAP, which is very convenient.

## Cyclic groups

$C_n$, the cyclic group of order $n$, has the following presentation:

$$
C_n=\left\langle a \mid a^n=e\right\rangle
$$

Cyclic group can be constructed and examined in GAP by the corresponding functions:

```gap
gap> C2 := CyclicGroup(2);
<pc group of size 2 with 1 generator>
gap> StructureDescription(C2);
"C2"
gap> IsCyclic(C2);
true
gap> MinimalGeneratingSet(C2);
[ f1 ]
gap> C2_ := AllGroups(2)[1];
<pc group of size 2 with 1 generator>
gap> IsIsomorphicGroup(C2, C2_);
gap> C2_ := SimplifiedFpGroup(Image(IsomorphismFpGroup(C2)));
<fp group of size 2 on the generators [ F1 ]>
gap> RelatorsOfFpGroup(C2_);
[ F1^2 ]
```

Let's use the `sonata` package to check if the two groups are isomorphic:

```gap
gap> LoadPackage("sonata");

  ___________________________________________________________________________
 /        ___
||       /   \                 /\    Version 2.9.6
||      ||   ||  |\    |      /  \               /\       Erhard Aichinger
 \___   ||   ||  |\\   |     /____\_____________/__\      Franz Binder
     \  ||   ||  | \\  |    /      \     ||    /    \     Juergen Ecker
     ||  \___/   |  \\ |   /        \    ||   /      \    Peter Mayr
     ||          |   \\|  /          \   ||               Christof Noebauer
 \___/           |    \|                 ||

 System    Of   Nearrings     And      Their Applications
 Info: https://gap-packages.github.io/sonata/

true
gap> C2_ := AllGroups(2)[1];
<pc group of size 2 with 1 generator>
gap> IsIsomorphicGroup(C2, C2_);
true
```

This section is inspired by SO question [1](https://math.stackexchange.com/questions/3185071/identifying-the-group-in-gap), .

## The quaternion group

The quaternion group $Q_8$ is a non-abelian group of order 8. It has the following presentation:

$$
\mathrm{Q}_8=\left\langle\bar{e}, i, j, k \mid \bar{e}^2=e, i^2=j^2=k^2=i j k=\bar{e}\right\rangle
$$

Another (less intuitive) presentation of $Q_8$ is:

$$
\mathrm{Q}_8=\left\langle a, b \mid a^4=e, a^2=b^2, b a=a^{-1} b\right\rangle
$$

First, construct the group $Q_8$ by its presentation in GAP:

```gap
gap> Q8_pre := FreeGroup( "n", "i", "j", "k" );
<free group on the generators [ n, i, j, k ]>
gap> AssignGeneratorVariables(Q8_pre);
#I  Assigned the global variables [ n, i, j, k ]
gap> Q8_rel := ParseRelators(Q8_pre, "i^2 = j^2 = k^2 = i*j*k = n");
[ i^2*n^-1, j^2*n^-1, k^2*n^-1, i*j*k*n^-1 ]
gap> Q8 := Q8_pre / Q8_rel;
<fp group on the generators [ n, i, j, k ]>
```
Let's try to see if GAP recognizes $Q_8$:

```gap
gap> StructureDescription(Q8);
"Q8"
```

Cool, now let's learn more about $Q_8$:

```gap
gap> StructureDescription(Center(Q8));
"C2"
gap> StructureDescription(DerivedSubgroup(Q8));
"C2"
gap> hs := List(ConjugacyClassesSubgroups(Q8),Representative);
[ Group([  ]), Group([ n ]), Group([ n, j ]), Group([ n, j*i^-1 ]), Group([ n, i ]), Q8 ]
gap> g := Q8;
Q8
gap> StructureDescription(g/Intersection(DerivedSubgroup(g),Center(g)));
"C2 x C2"
```

What's the simplified presentation of $Q_8$?

```gap
gap> MinimalGeneratingSet(Q8);
[ j*k, j ]
gap> Q8_ := SimplifiedFpGroup(Image(IsomorphismFpGroup(Q8)));
<fp group of size 8 on the generators [ i, j ]>
gap> RelatorsOfFpGroup(Q8_);
[ j*i*j^-1*i, j^2*i^-2 ]
```

$Q_8$ can also be constructed by the `QuaternionGroup` function, we can check the isomorphism:

```gap
gap> GeneratorsOfGroup(Q8);
[ n, i, j, k ]
gap> RelatorsOfFpGroup(Image(IsomorphismFpGroup(Q8)));
[ i^2*n^-1, j^2*n^-1, k^2*n^-1, i*j*k*n^-1 ]
gap> Q8_ := QuaternionGroup(8);                                       
<pc group of size 8 with 3 generators>
gap> GeneratorsOfGroup(Q8_);
[ x, y, y2 ]
gap> RelatorsOfFpGroup(Image(IsomorphismFpGroup(Q8_)));
[ F1^2*F3^-1, F2^-1*F1^-1*F2*F1*F3^-1, F3^-1*F1^-1*F3*F1, F2^2*F3^-1, F3^-1*F2^-1*F3*F2, F3^2 ]
gap> IsIsomorphicGroup(Q8, Q8_);
true
```

The better way (after GAP 4.5) is

```gap
gap> Q8_ := QuaternionGroup(IsFpGroup, 8);
<fp group of size 8 on the generators [ r, s ]>
gap> GeneratorsOfGroup(Q8_);
[ r, s ]
gap> RelatorsOfFpGroup(Image(IsomorphismFpGroup(Q8_)));
[ r^2*s^-2, s^4, r^-1*s*r*s ]
gap> IsIsomorphicGroup(Q8, Q8_);
true
```

This section is inspired by SO answers [1](https://math.stackexchange.com/a/3213387/276408), [2](https://math.stackexchange.com/a/774952/276408), [3](https://math.stackexchange.com/questions/1618446/how-can-i-display-generators-or-a-minimal-generating-set-with-gap).

## The group algebra of $Q_8$

```gap
gap> FG:=GroupRing(Rationals,Q8_);
<algebra-with-one over Rationals, with 2 generators>
gap> IsGroupAlgebra(FG);
true
gap> RadicalOfAlgebra(FG);
<algebra of dimension 0 over GF(5)>
gap> WedderburnDecomposition(FG);
[ Rationals, Rationals, Rationals, Rationals, <crossed product with center Rationals over GaussianRationals of a group of size 2> ]
```

This section is inspired by [an SO question](https://math.stackexchange.com/a/432638/276408) and the [Abstract Algebra in GAP](https://www.math.colostate.edu/~hulpke/CGT/howtogap.pdf).