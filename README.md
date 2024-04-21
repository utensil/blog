# Blog

My math-intensive learning notes are hosted in this blog. Built with:

- [Hugo](https://gohugo.io/): a popular static site generator for blogs, with [PaperMod](https://github.com/adityatelange/hugo-PaperMod) as base template, [MathJax](https://www.mathjax.org/) support, and [hugo-cite](https://github.com/loup-brun/hugo-cite) for citation support.
- [Quarto](https://quarto.org/): via [hugo-md](https://quarto.org/docs/output-formats/hugo.html) support, with [Pandoc](https://pandoc.org/) as the universal converter, for:
  - [academic writing](https://quarto.org/docs/authoring/front-matter.html)
  - [Jupyter](https://jupyter.org/) and [Observable JS](https://quarto.org/docs/interactive/ojs/) notebook integration
  - [Typst PDF rendering](https://quarto.org/docs/output-formats/typst.html) then embed with `iframe`.
- TODO: [typst.ts](https://github.com/Myriad-Dreamin/typst.ts): for Typst SVG rendering, thus a more friendly Web experience.

The illustrative diagrams in this blog aim to be reproduceable, they are made by one of:

- [Pikchr](https://pikchr.org/): an open-source text-to-diagram tool, the language is [simple](https://pikchr.org/home/doc/trunk/doc/grammar.md) yet has great support for [relative positioning](https://pikchr.org/home/doc/trunk/doc/position.md) and [flexible path guiding](https://pikchr.org/home/doc/trunk/doc/locattr.md).
- [D2](https://d2lang.com/), a modern diagram scripting language, [preferred](https://text-to-diagram.com/) over [PlantUML](https://plantuml.com/), [Mermaid](https://mermaid-js.github.io/mermaid/#/), and [Graphviz](https://graphviz.org/), for its great layout support for complex diagrams and its declarative design.
- [draw.io]((https://github.com/jgraph/drawio)): an open-source [semi](https://www.drawio.com/blog/smart-diagram-generation)-[auto](https://www.drawio.com/doc/faq/apply-layouts) [feature-rich](https://www.drawio.com/features#easy-to-use-diagram-editor) diagram tool, using `.drawio.svg` format to be both editable and web-presentable.
- TODO: [TiKZ](https://github.com/pgf-tikz/pgf) with static generation powered by [TinyTeX](https://yihui.org/tinytex/) that [comes with Quarto](https://github.com/quarto-dev/quarto-actions/tree/main/setup).

## Local Development

Install [Hugo](https://gohugo.io/installation/) and [Quarto](https://quarto.org/docs/get-started/), or simply run the following on MacOS:

```bash
brew install hugo
brew install quarto
```

Find out which Python quarto is using:

```bash
quarto check
```

and use it as `python3` in the following commands:

```bash
python3 -m pip install jupyter --break-system-packages
python3 -m IPython kernel install
python3 -m pip install -r requirements.txt --break-system-packages
```

`--break-system-packages` is needed if you are using a system Python installation, installed by brew for example, which is the one used by quarto for me under MacOS, despite that I'm already using `pyenv` to manage Python versions.

Initialize the submodules for Hugo themes and extensions:

```bash
git submodule update --init --recursive
```

Finally, run in one terminal:

```bash
quarto preview --no-serve --no-browser --render all
```

and in another terminal:

```bash
hugo serve -w --forceSyncStatic
```

then navigate to something like `http://localhost:1313/blog/` in your browser, as prompted.

Or, if you are simply working on a vanilla markdown post, just run:

```bash
quarto render && hugo serve -w --forceSyncStatic
```

which will only live reload the vanilla markdown files.