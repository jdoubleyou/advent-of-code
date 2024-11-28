import logging
import re
from turtle import pu
from turtle import st


def print_stacks(stacks):
    s = ""
    for stack in stacks:
        for container in stack:
            s += container
        s += "\n"
    logging.info(s)


def parse_stacks_and_moves(puzzle_input: str):
    initial, movements = puzzle_input.split("\n\n")
    containers = initial.splitlines()
    column_count = int(list(filter(None, containers[-1].split()))[-1])
    containers = containers[:-1]

    pattern = re.compile("move (\\d+) from (\\d+) to (\\d+)")
    movements = [
        [int(i) for i in pattern.match(movement).groups()]
        for movement in movements.splitlines()
    ]

    stacks = [[] for _ in range(column_count)]
    for row in containers:
        stack_index = 0
        while row:
            head = row[0:3].replace("[", "").replace("]", "")
            row = row[4:]
            if head.strip():
                stacks[stack_index] = [head] + stacks[stack_index]
            stack_index += 1

    logging.info("initial")
    print_stacks(stacks)

    return stacks, movements


def apply_moves(puzzle_input: str, reverse_move=True):
    stacks, movements = parse_stacks_and_moves(puzzle_input)

    logging.info("movements")
    for movement in movements:
        amount, _from_1_index, to_1_index = movement
        _from, to = _from_1_index - 1, to_1_index - 1
        moved = stacks[_from][-amount:]
        stacks[to] += list(reversed(moved) if reverse_move else moved)
        logging.info(
            f"moving {moved}({len(moved)}/{amount}) from {_from_1_index} to {to_1_index}"
        )
        stacks[_from] = stacks[_from][:-amount]
        print_stacks(stacks)

    print_stacks(stacks)
    return "".join([i[-1] for i in stacks])


def part_one(puzzle_input: str):
    """
        [D]
    [N] [C]
    [Z] [M] [P]
     1   2   3

    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
    """

    return apply_moves(puzzle_input)


def part_two(puzzle_input: str):
    """
        [D]
    [N] [C]
    [Z] [M] [P]
     1   2   3

    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
    """

    return apply_moves(puzzle_input, reverse_move=False)
