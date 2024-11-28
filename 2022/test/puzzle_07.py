from src import day_07

from .utils import verify


def test_puzzle_07():
    verify(
        day_07,
        test={
            "example.txt": (95437, 24933642),
            "input.txt": (1297159, 3866390),
        },
        real=["input.txt"],
    )
