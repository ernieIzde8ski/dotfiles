# ernieIzde8ski/dotfiles

Linux dotfiles in chezmoi format. pre-commit requires python3.

```sh
chezmoi init 'https://github.com/ernieIzde8ki/dotfiles.git'
chezmoi apply ~/.config/chezmoi/chezmoi.yaml
chezmoi apply

# for contributing changes
chezmoi cd
python3 -m venv .venv
. .venv/bin/activate
pip install pre-commit
pre-commit install
```
