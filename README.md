# Blog

My math-intensive learning notes are hosted in this blog. Built with:

- [Hugo](https://gohugo.io/): a popular static site generator for blogs, with [PaperMod](https://github.com/adityatelange/hugo-PaperMod) as base template, [MathJax](https://www.mathjax.org/) [support](https://gohugo.io/content-management/mathematics/), and [hugo-cite](https://github.com/loup-brun/hugo-cite) for citation support.
- [Quarto](https://quarto.org/)  ([example post](https://utensil.github.io/blog/posts/quarto-test/)): via [hugo-md](https://quarto.org/docs/output-formats/hugo.html) support, with [Pandoc](https://pandoc.org/) as the universal converter, for:
  - [academic writing](https://quarto.org/docs/authoring/front-matter.html)
  - [Jupyter](https://jupyter.org/) and [Observable JS](https://quarto.org/docs/interactive/ojs/) notebook integration
- [Typst](https://typst.app/) ([example post](https://utensil.github.io/blog/posts/typst-test/))
  - [PDF rendering](https://quarto.org/docs/output-formats/typst.html)
  - [SVG rendering](https://github.com/Myriad-Dreamin/typst.ts) for a more friendly Web experience.

The illustrative diagrams in this blog aim to be reproduceable, they are made by one of:

- [Pikchr](https://pikchr.org/): an open-source text-to-diagram tool, the language is [simple](https://pikchr.org/home/doc/trunk/doc/grammar.md) yet has great support for [relative positioning](https://pikchr.org/home/doc/trunk/doc/position.md) and [flexible path guiding](https://pikchr.org/home/doc/trunk/doc/locattr.md).
- [D2](https://d2lang.com/), a modern diagram scripting language, [preferred](https://text-to-diagram.com/) over [PlantUML](https://plantuml.com/), [Mermaid](https://mermaid-js.github.io/mermaid/#/), and [Graphviz](https://graphviz.org/), for its great layout support for complex diagrams and its declarative design.
- [draw.io]((https://github.com/jgraph/drawio)): an open-source [semi](https://www.drawio.com/blog/smart-diagram-generation)-[auto](https://www.drawio.com/doc/faq/apply-layouts) [feature-rich](https://www.drawio.com/features#easy-to-use-diagram-editor) diagram tool, using `.drawio.svg` format to be both editable and web-presentable.
- TODO: [TiKZ](https://github.com/pgf-tikz/pgf) with static generation powered by [TinyTeX](https://yihui.org/tinytex/) that [comes with Quarto](https://github.com/quarto-dev/quarto-actions/tree/main/setup).

## Local Development

Install the following tools per instructions:

- [Hugo](https://gohugo.io/installation/)
- [Quarto](https://quarto.org/docs/get-started/)
- [D2](https://d2lang.com/tour/install)
- [Watchexec](https://watchexec.github.io/downloads/watchexec/)

Or simply run the following on MacOS if you have [Homebrew](https://brew.sh/) installed:

```bash
brew install hugo quarto d2 watchexec
```

Particularly, Pikchr will be installed from source by `scripts/make_pikchr.sh` on first run.

Find out which Python Quarto is using:

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

Run the following to make D2, Pikchr diagrams and Typst documents for the first time:

```bash
./scripts/make_all.sh
```

Finally, run `./watch.sh` to do the following 3 tasks in on go.

If you are simply working on a vanilla markdown post, just run:

```bash
hugo serve -w --forceSyncStatic --disableFastRender --ignoreCache --noHTTPCache # --gc --cleanDestinationDir
```

then navigate to something like `http://localhost:1313/blog/` in your browser, as prompted.

If you are authoring with Quarto, run in a separate terminal:

```bash
quarto preview --no-serve --no-browser --render all
```

If you are authoring with Typst/D2/Pikchr/Bibliography, run in a separate terminal:

```bash
# watchexec --ignore-nothing -vvv --project-origin . -w content/posts/math-2024 -e d2,pikchr,typ,bib --only-emit-events --emit-events-to json-stdio --print-events --notify --poll 500ms
watchexec --on-busy-update queue --poll 500ms -e d2,pikchr,typ,bib --emit-events-to=stdio -- ./scripts/make_changed.sh
```