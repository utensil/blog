
#let setup(body) = {
    // light mode
    let fg = rgb("000000")
    let bg = rgb("ffffff")
    // dark mode
    let fg = rgb("fdfdfd")
    let bg = rgb(29, 30, 32)

    set page(width: 750pt, height: auto, margin: (x: 0.1cm, y: 0.1cm))
    set page(fill: bg)
    set text(fill: fg)
    set text(size: 16pt)
    set heading(numbering: "1.")

    // dark mode
    set table(stroke: fg)

    body
}