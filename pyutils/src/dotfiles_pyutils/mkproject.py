#!/usr/bin/env python3

import os
import subprocess
from pathlib import Path
from typing import Annotated, cast

import typer

from ._abort import abort

app = typer.Typer()

_HOME = os.getenv("HOME")
assert _HOME


EXTERNAL_DIRECTORY = Path("/mnt/indarys/projects/TEMPLATES")
LOCAL_DIRECTORY = Path(f"{_HOME}/.local/state/cc-templates")
TEMPLATE_DIRECTORIES = (EXTERNAL_DIRECTORY, LOCAL_DIRECTORY)

GIT_URL = r"https://github.com/ernieIzde8ski/cc-templates.git"


def get_templates(ensure_exists: bool | None):
    result: Path

    for fp in TEMPLATE_DIRECTORIES:
        path = Path(fp)
        if path.is_dir():
            result = path
            break
    else:
        if ensure_exists is None:
            ensure_exists = typer.prompt(
                "Could not find template directory. Clone from source? "
            )
        if not ensure_exists:
            raise typer.Abort()
        result = LOCAL_DIRECTORY
        parent = result.parent
        parent.mkdir(exist_ok=True, parents=True)
        _ = subprocess.check_output(("git", "-C", parent, "clone", result))

    for path in (result / "templates").iterdir():
        if path.is_dir() and (path / "cookiecutter.json").exists():
            yield path


def list_templates(ctx: typer.Context, value: bool | None):
    if not value:
        return True
    ensure_root_exists: bool | None = ctx.params.get("ensure_exists", None)
    templates = get_templates(ensure_root_exists)
    for template in templates:
        print(template.name)
    raise typer.Exit()


@app.command()
def main(
    template_name: Annotated[str, typer.Argument(help="Name of template to generate.")],
    ensure_exists: Annotated[
        bool | None,
        typer.Option(
            "-E",
            "--ensure-exists",
            help="Ensure that the root template directory exists, "
            "cloning from source if not available.",
        ),
    ] = None,
    _list: Annotated[
        bool,
        typer.Option(
            "-l",
            "--list",
            "--list-templates",
            help="List available templates.",
            callback=list_templates,
        ),
    ] = False,
) -> None:
    templates = get_templates(ensure_exists)
    templates = filter(lambda _template: _template.name == template_name, templates)
    template = next(templates, None)

    if template is None:
        abort("No template with given name:", repr(template_name))
    from cookiecutter.main import cookiecutter

    fp = cast(str, cookiecutter(template=str(template)))
    typer.secho(f"Generated template at {fp}", err=True)
