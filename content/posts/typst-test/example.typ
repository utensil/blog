// This is for adjusting the size so it can fit into the blog post
#import "../config.typ" : setup

#let fulltext = [

= Examples

Paragraph 1.

Paragraph 2.

Paragraph 3 \
with line break.

== Simple content

- *bold*
- _emphasis_
- `code`
- "quotes"
    - Indented
    + numbered
    + #lorem(10)
    + #underline[underline]
    + #text(orange, size: 0.8em)[orange smaller text]
- #link("https://typst.app/docs/reference/")[link]
- #[[]]

```typ
_fenced code block_ with *syntax highlighting*
```

#quote(block: true, attribution: "Me")[
  We are not born to be doomed on one planet.
]

#quote(block: false, attribution: "Me")[
  Never lose hope.
]

inline math: $a + b/c = sum_i x^i$

display math:

$
7.32 beta +
  sum_(i=0)^nabla
    (Q_i (a_i - epsilon)) / 2
$

#set heading(numbering: "I.1:")

== Figure

#figure(
  caption: [caption],
  image("./fibonacci.artifact.svg", width: 80%)
)

#set heading(numbering: "1.1.")

== Tables

#set rect(height: 1em)

#table(
  columns: 2,
  [Points], rect(width: 72pt),
  [Millimeters], rect(width: 25.4mm),
  [Centimeters], rect(width: 2.54cm),
  [Inches], rect(width: 1in),
  [Relative to font size], rect(width: 6.5em)
)

== Show rules

#show "green text": text(green)[text]

Here is some green text.

#show emph: set text(blue)

_emphasized_ text is now blue.

#show heading.where(level: 3): set align(center)

=== centered heading

#show heading.where(level: 3): it => {
    set align(right)
    set text(red)
    // set heading(numbering: "1.I:") // not working
    block(it.body)
    //it
}

=== red heading

#let apply-template(body, name: "My document") = {
  show heading.where(level: 4): emph
  set heading(numbering: "1.1")

  align(center, text(name, size: 2em))

  body
}

#show: apply-template.with(name: "Report")

#lorem(20)

Boxes are inline: #box(image("./fibonacci.artifact.svg", height: 3em)).

Blocks are not: #block(image("./fibonacci.artifact.svg", width: 90%)).

#box(stroke: red, inset: 1em)[Box text]
#block(stroke: red, inset: 1em)[Block text]
#rect(height: auto)[Rect text] // without auto, would be affected by the rect height

#figure(
  text(size: 5em)[I],
  caption: [I'm cool, right?],
)

Horizontal #h(1cm) spacing.
#v(1cm)
And some vertical too!

Double font size: #box(stroke: red, baseline: 40%, height: 2em, width: 2em)

This line width is 50% of the box width: #box(stroke: red, width: 4em, inset: (y: 0.5em), line(length: 50%))


Single fraction length just takes maximum size possible to fill the parent:

Left #h(1fr) Right

#rect(height: 1em)[
  #h(1fr)
]

If you use several fractions inside one parent, they will take all remaining space proportional to their number:

Left #h(1fr) Left-ish #h(2fr) Right

The rest are shown in two columns except for this paragraph. #lorem(20)

#show: rest => columns(2, rest)

#lorem(20)

// #show: rest => columns(1, rest) // not working

]

#show : setup(fulltext)
