#!/usr/bin/env python3
# pyright: reportMissingTypeStubs = false
# pyright: reportImplicitStringConcatenation = false

import subprocess
from datetime import datetime, timedelta
from typing import Annotated, cast

import typer

from .._crash import crash
from .path import Path, resolve_first_path

app = typer.Typer()

EXTERNAL_DIRECTORY: Path = (
    resolve_first_path("${INDARYS}", "/mnt/indarys", mode="required")
    / "projects/TEMPLATES/templates"
)
LOCAL_DIRECTORY = (
    resolve_first_path(
        "${PYU_TEMPLATES}",
        "${XDG_STATE_HOME}/cc-templates",
        "${HOME}/.local/state/cc-templates",
        mode="required",
    )
    / "templates"
)
TEMPLATE_DIRECTORIES = (EXTERNAL_DIRECTORY, LOCAL_DIRECTORY)


GIT_URL = r"https://github.com/ernieIzde8ski/cc-templates.git"
EPILOG = f"""
Creates a new project in a subfolder of the current directory,
using cookiecutter templates from this repository:

\b

\b\t{GIT_URL}

\b

mkproject sources templates from these directories, if available:

\b

\b\t{"\n\n\b\t".join(p.as_posix() for p in TEMPLATE_DIRECTORIES)}
"""

UPDATE_AFTER = timedelta(days=7)
"""Default amount of time before re-attempting to `git-pull` the template directory."""


def _is_out_of_date(timestamp_file: Path, allotted_time: timedelta):
    mtime_float = timestamp_file.stat().st_mtime
    mtime = datetime.fromtimestamp(mtime_float)
    time_since = datetime.now() - mtime
    return time_since > allotted_time


def get_git_root(path: Path) -> Path:
    git_output = subprocess.run(
        ("git", "-C", path, "rev-parse", "--show-toplevel"),
        stdout=subprocess.PIPE,
        check=True,
    )
    decoded = git_output.stdout.decode("utf-8")
    # remove trailing newline
    return Path(decoded[:-1])


def ensure_tmpl_dir(tmpl_dir: Path, update_after: timedelta):
    git_dir = get_git_root(tmpl_dir)
    timestamp_file = git_dir / ".git" / "last-pull"

    if timestamp_file.exists() and _is_out_of_date(timestamp_file, update_after):
        _ = subprocess.run(("git", "-C", git_dir, "pull"), check=True)

    timestamp_file.touch()


def get_tmpl_dir(ensure_exists: bool | None, update_after: timedelta):
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
        _ = subprocess.check_output(("git", "-C", parent, "clone", GIT_URL, result))

    ensure_tmpl_dir(result, update_after)

    return result


def ls_tmpls(ctx: typer.Context, value: bool | None):
    if not value:
        return True
    ensure_root_exists: bool | None = ctx.params.get("ensure_exists", None)
    tmpl_dir = get_tmpl_dir(ensure_root_exists, UPDATE_AFTER)
    for template in tmpl_dir.iterdir():
        print(template.name)
    raise typer.Exit()


@app.command(epilog=EPILOG)
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
            callback=ls_tmpls,
        ),
    ] = False,
) -> None:
    tmpl_dir = get_tmpl_dir(ensure_exists=ensure_exists, update_after=UPDATE_AFTER)
    tmpls = (tmpl_dir / template_name, tmpl_dir / (template_name + "template"))
    for __tmpl in tmpls:
        if __tmpl.exists():
            tmpl = __tmpl
            break
    else:
        print(tmpls)
        crash("No template with given name:", repr(template_name))

    from cookiecutter.main import cookiecutter  # pyright: ignore[reportUnknownVariableType]

    fp = cast(str, cookiecutter(template=str(tmpl)))
    typer.secho(f"Generated template at {fp}", err=True)
