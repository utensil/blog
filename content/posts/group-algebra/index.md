---
title: "Studying group algebras with GAP"
publishDate: 2024-03-21T10:00:00+08:00
draft: true
---

This post studies group algebras with [GAP](https://github.com/gap-system/gap), focusing on a few interested groups. See [*My math interests in 2024: Group Algebra*](../math-2024/) for context.

It's helpful to read [GAP Manual](https://docs.gap-system.org/doc/ref/chap0_mj.html) and [SO questions](https://math.stackexchange.com/search?q=%5Bgroup-theory%5D+GAP+group+algebra) before using GAP.

## Installation

I'm using Mac, so I ran the following commands to install GAP:

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

## Cyclic groups

$C_n$, the cyclic group of order $n$, has the following presentation:

$$
C_n=\left\langle a \mid a^n=e\right\rangle
$$

```gap
gap> C2 := CyclicGroup(2);
<pc group of size 2 with 1 generator>
gap> StructureDescription(C2);
"C2"
gap> IsCyclic(C2);
true
gap> C2_ := AllGroups(2)[1];
<pc group of size 2 with 1 generator>
gap> IsIsomorphicGroup(C2, C2_);
gap> C2_ := SimplifiedFpGroup(Image(IsomorphismFpGroup(C2)));
<fp group of size 2 on the generators [ F1 ]>
gap> RelatorsOfFpGroup(C2_);
[ F1^2 ]
```

## The quaternion group

The quaternion group $Q_8$ is a non-abelian group of order 8. It has the following presentation:

$$
\mathrm{Q}_8=\left\langle\bar{e}, i, j, k \mid \bar{e}^2=e, i^2=j^2=k^2=i j k=\bar{e}\right\rangle
$$

Another (less intuitive) presentation of $Q_8$ is:

$$
\mathrm{Q}_8=\left\langle a, b \mid a^4=e, a^2=b^2, b a=a^{-1} b\right\rangle
$$

Great, let's run some GAP code! Note that the code can be copy-pasted into a GAP console, and `gap>` will be omitted by GAP, which is very convenient.

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
gap> Q8_ := SimplifiedFpGroup(Image(IsomorphismFpGroup(Q8)));
<fp group of size 8 on the generators [ i, j ]>
gap> RelatorsOfFpGroup(Q8_);
[ j*i*j^-1*i, j^2*i^-2 ]
```

This section is inspired by SO answers [1](https://math.stackexchange.com/a/3213387/276408), [2](https://math.stackexchange.com/a/774952/276408).


