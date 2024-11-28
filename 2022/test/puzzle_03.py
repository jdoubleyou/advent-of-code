from src import day_03

from .utils import verify


def test_puzzle_03():
    verify(
        day_03,
        test={
            "example.txt": (157, 70),
            "input.txt": (7848, 2616),
        },
        real=["input.txt"],
    )
