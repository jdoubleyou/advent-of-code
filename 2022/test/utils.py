import logging
import typing as t
from pathlib import Path

import pytest


def verify(mod, test: dict[str, dict[t.Callable[[str], t.Any], str]], real: list[str]):
    mod_name = mod.__name__.split(".")[-1]
    base_dir = Path.cwd()
    for test_file, test_cases in test.items():
        prefixed_test_file = f"inputs/{mod_name}/{test_file}"
        with open(base_dir / prefixed_test_file, "r") as f:
            logging.debug(f"reading {base_dir / prefixed_test_file}")
            contents = f.read()
            logging.debug(f"contents ({base_dir / prefixed_test_file}): " + contents)
            if not test_cases or test_cases == (None, None):
                pytest.skip("No test cases to run.")

            expected_part_one, expected_part_two = test_cases
            assert expected_part_one == getattr(mod, "part_one")(contents)
            assert expected_part_two == getattr(mod, "part_two")(contents)

    if not real:
        pytest.skip("No real input files to run.")

    for real_file in real:
        prefixed_real_file = f"inputs/{mod_name}/{real_file}"
        with open(base_dir / prefixed_real_file, "r") as f:
            logging.debug(f"reading {base_dir / prefixed_real_file}")
            contents = f.read()
            logging.debug(f"contents ({base_dir / prefixed_real_file}): " + contents)

            for index, func_name in enumerate(["part_one", "part_two"]):
                prefixed_out_file = f"outputs/{mod_name}/output_{index+1}"
                p = base_dir / prefixed_out_file
                if not p.parent.exists():
                    p.parent.mkdir()
                with open(p, "w") as out:
                    logging.debug(f"writing {p}")
                    func = getattr(mod, func_name)
                    result = str(func(contents))
                    result_message = f"RESULT ({func.__name__}): {result}"
                    out.write(result_message)
                    logging.info(result_message)
                    print("\n    " + result_message, end="")
            print()
