from typing import Never

import typer


def abort(*objs: object) -> Never:
    """Prints error message in red to the terminal, before ultimately raising `typer.Abort`."""
    msg = " ".join(str(obj) for obj in objs)
    typer.secho(msg, err=True, fg="red")
    raise typer.Abort()
