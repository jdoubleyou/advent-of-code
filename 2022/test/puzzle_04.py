from src import day_04

from .utils import verify


def test_puzzle_04():
    verify(
        day_04,
        test={
            "example.txt": (2, 4),
            "input.txt": (567, 907),
        },
        real=["input.txt"],
    )
