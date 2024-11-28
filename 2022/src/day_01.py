import logging


def part_one(puzzle_input: str):
    logging
    return max(
        [
            sum([int(e) for e in elf.split()])
            for elf in puzzle_input.strip().split("\n\n")
        ]
    )


def part_two(puzzle_input: str):
    return sum(
        list(
            reversed(
                sorted(
                    [
                        sum([int(e) for e in elf.split()])
                        for elf in puzzle_input.strip().split("\n\n")
                    ]
                )
            )
        )[:3]
    )
