import os
import pathlib
from collections.abc import Iterable, Iterator
from typing import Literal, Self, overload

import re

_ENV_COMPONENT_PATTERN = re.compile(r"^\$\{(.+)\}$")


class Path(pathlib.Path):
    @staticmethod
    def __resolve_env(components: Iterable[str]) -> Iterator[str | None]:
        for comp in components:
            m = _ENV_COMPONENT_PATTERN.match(comp)
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
