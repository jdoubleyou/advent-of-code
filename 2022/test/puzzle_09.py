from src import day_09

from .utils import verify


def test_puzzle_09():
    verify(
        day_09,
        test={
            "example.txt": (13, 1),
            "example1.txt": (88, 36),
        },
        real=["input.txt"],
    )
