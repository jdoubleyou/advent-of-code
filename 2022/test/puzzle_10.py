from src import day_10

from .utils import verify


def test_puzzle_10():
    verify(
        day_10,
        test={
            "example.txt": (None, None),
        },
        real=["input.txt"],
    )
