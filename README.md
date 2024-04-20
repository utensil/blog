# blog

## Local Development

Install [hugo](https://gohugo.io/installation/) and [quarto](https://quarto.org/docs/get-started/).

Find out which Python quarto is using:

```bash
quarto check
```

and use it as `python3` in the following commands:

```bash
python3 -m pip install jupyter  --break-system-packages
python3 -m IPython kernel install
python3 -m pip install -r requirements.txt --break-system-packages
```

`--break-system-packages` is needed if you are using a system Python installation, installed by brew for example, which is the one used by quarto for me under MacOS, despite that I'm already using `pyenv` to manage Python versions.

Finally, run:

```bash
quarto preview --no-browser --port 1313
```

then navigate to something like `http://localhost:1313/blog/` in your browser, as prompted.

Or, if you are simply working on a vanilla markdown post, just run:

```bash
quarto render && hugo serve -w --forceSyncStatic
```

which will only live reload the vanilla markdown files.