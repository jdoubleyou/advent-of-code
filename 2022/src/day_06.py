from .utils import windowed


def find_window(puzzle_input: str, window_len: int):
    for iteration, window in enumerate(windowed(puzzle_input, window_len)):
        if len(set(window)) == window_len:
            return iteration + window_len


def part_one(puzzle_input: str):
    return find_window(puzzle_input, 4)


def part_two(puzzle_input: str):
    return find_window(puzzle_input, 14)
