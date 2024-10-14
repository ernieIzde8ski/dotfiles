from collections.abc import Iterable
from typing import Never

import typer


def _join(objects: Iterable[object], sep: str = " ") -> str:
    return sep.join(str(object) for object in objects)


def crash(*objects: object, exit_code: int = 1) -> Never:
    """
    Prints error message in red to the terminal,
    before ultimately raising `typer.Exit`.
    """
    message = _join(objects)
    message = f"fatal: {message}"
    typer.secho(message, err=True, fg="red")
    raise typer.Exit(exit_code)
