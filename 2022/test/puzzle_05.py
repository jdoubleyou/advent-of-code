from src import day_05

from .utils import verify


def test_puzzle_05():
    verify(
        day_05,
        test={
            "example.txt": ("CMZ", "MCD"),
            "input.txt": ("VWLCWGSDQ", "TCGLQSLPW"),
        },
        real=["input.txt"],
    )
