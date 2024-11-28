from typing import Iterable


def windowed(source: Iterable, window_size: int):
    assert window_size > 0
    window = (0, window_size)
    while window[1] <= len(source):
        yield source[window[0] : window[1]]
        f, s = window
        window = (f + 1, s + 1)
