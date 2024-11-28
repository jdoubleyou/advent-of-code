import pytest

pytest.register_assert_rewrite("test.utils")

from logging import basicConfig

basicConfig(filename="__logs__/out.log", format="%(message)s", filemode="w")
