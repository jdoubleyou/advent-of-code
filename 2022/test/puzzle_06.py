from src import day_06

from .utils import verify


def test_puzzle_06():
    verify(
        day_06,
        test={
            "example.txt": (7, 19),
            "example2.txt": (5, 23),
            "example3.txt": (6, 23),
            "example4.txt": (10, 29),
            "example5.txt": (11, 26),
        },
        real=["input.txt"],
    )
