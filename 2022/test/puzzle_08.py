from src import day_08

from .utils import verify


def test_puzzle_08():
    verify(
        day_08,
        test={
            "example.txt": (21, 8),
            "input.txt": (1796, 288120),
        },
        real=["input.txt"],
    )
