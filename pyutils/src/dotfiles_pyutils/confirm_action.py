from enum import Enum
from typing import Annotated, Never

import typer
from click import secho

__all__ = ["__all__"]

app = typer.Typer()


class Choice(str, Enum):
    yes = "yes"
    no = "no"
    none = "none"

    def input_repr(self) -> str:
        match self:
            case Choice.yes:
                return "[Y/n]"
            case Choice.no:
                return "[y/N]"
            case Choice.none:
                return "[Y/N]"

    def exit(self) -> Never | None:
        match self:
            case Choice.yes:
                raise typer.Exit(0)
            case Choice.no:
                raise typer.Exit(1)
            case Choice.none:
                pass


@app.command()
def main(
    message: Annotated[str, typer.Argument()] = "",
    default: Annotated[Choice, typer.Option("-d", "--default")] = Choice.none,
    format_msg: Annotated[bool, typer.Option("--format/--preserve")] = True,
) -> None:
    if format_msg:
        message = message.strip() + " " + default.input_repr() + " "
    try:
        while True:
            text = input(message)
            match text[:1].lower():
                case "y":
                    raise typer.Exit(0)
                case "n":
                    raise typer.Exit(1)
                case "":
                    default.exit()
                case _:
                    secho(f"unexpected input: {text}", fg="red", err=True)
    except EOFError:
        default.exit()
        secho()
        secho("stdin is closed, but `--default` is not set", fg="red", err=True)
        raise typer.Exit(2)
