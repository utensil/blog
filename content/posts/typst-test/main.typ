#set page(width: 595.28pt, height: auto, margin: (x: 1cm, y: 1cm))

// light mode
#let fg = rgb("000000")
#let bg = rgb("ffffff")
// dark mode
#let fg = rgb("fdfdfd")
#let bg = rgb(29, 30, 32)

#set page(fill: bg)
#set text(fill: fg)

#set text(size: 16pt)

#set heading(numbering: "1.")

= Fibonacci sequence

The Fibonacci sequence is defined through the
recurrence relation $F_n = F_(n-1) + F_(n-2)$.
It can also be expressed in _closed form:_

$ F_n = round(1 / sqrt(5) phi.alt^n), quad
  phi.alt = (1 + sqrt(5)) / 2 $

#let count = 8
#let nums = range(1, count + 1)
#let fib(n) = (
  if n <= 2 { 1 }
  else { fib(n - 1) + fib(n - 2) }
)

The first #count numbers of the sequence are:

#align(center, table(
  // dark mode
  stroke: fg,
  columns: count,
  ..nums.map(n => $F_#n$),
  ..nums.map(n => str(fib(n))),
))
