from src import day_02

from .utils import verify


def test_puzzle():
    verify(
        day_02,
        test={
            "example.txt": (15, 12),
            "input.txt": (12458, 12683),
        },
        real=["input.txt"],
    )
