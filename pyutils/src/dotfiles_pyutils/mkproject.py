#!/usr/bin/env python3
# pyright: reportMissingTypeStubs = false
# pyright: reportImplicitStringConcatenation = false

import os
import pathlib
import re
import subprocess
from collections.abc import Iterator, Iterable
from typing import Annotated, Literal, Self, cast, overload

import typer

from ._crash import crash

app = typer.Typer()

_env_component = re.compile(r"^\$\{(.+)\}$")


class Path(pathlib.Path):
    @staticmethod
    def __resolve_env(components: Iterable[str]) -> Iterator[str | None]:
        for comp in components:
            m = _env_component.match(comp)
            if m is not None:
                yield os.getenv(m[1])
            else:
                yield comp

    @overload
    def resolve_env(self, *, unset: Literal["ignore"]) -> Self: ...
    @overload
    def resolve_env(self, *, unset: Literal["deny"] = "deny") -> Self | None: ...

    def resolve_env(self, *, unset: Literal["ignore", "deny"] = "deny") -> Self | None:
        given_components = self.__resolve_env(self.parts)
        res_components: list[str] = []
        for component in given_components:
            match (component, unset):
                case (None, "deny"):
                    return
                case (None, "ignore"):
                    continue
                case (str() as s, _):
                    res_components.append(s)
        return type(self)(*res_components)


@overload
def resolve_first_path(*paths: str | Path, mode: Literal["optional"]) -> Path | None: ...
@overload
def resolve_first_path(
    *paths: str | Path, mode: Literal["required"] = "required"
) -> Path: ...
def resolve_first_path(
    *paths: str | Path, mode: Literal["optional", "required"] = "required"
):
    for fp in paths:
        path = Path(fp).resolve_env(unset="deny")
        if path is not None:
            return path
    if mode == "required":
        raise RuntimeError("Couldn't find path!")


EXTERNAL_DIRECTORY = (
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


def get_tmpl_dir(ensure_exists: bool | None):
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

    return result


def ls_tmpls(ctx: typer.Context, value: bool | None):
    if not value:
        return True
    ensure_root_exists: bool | None = ctx.params.get("ensure_exists", None)
    tmpl_dir = get_tmpl_dir(ensure_root_exists)
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
    tmpl_dir = get_tmpl_dir(ensure_exists=ensure_exists)
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
