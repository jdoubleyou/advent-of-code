from src import day_01

from .utils import verify


def test_puzzle():
    verify(
        day_01,
        test={
            "example.txt": (24000, 45000),
            "input.txt": (70698, 206643),
        },
        real=["input.txt"],
    )
