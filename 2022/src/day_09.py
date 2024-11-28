DEBUG = False


def print_grid(positions, head_pos, knots: list, tail_pos):
    print(f"{positions=}")
    size = [max(i[0] for i in positions), max(i[1] for i in positions)]
    size = [max(size[0], 5), max(size[1], 5)]
    print()
    print(size)
    for row in reversed(range(size[0] + 1)):
        for col in range(size[1] + 1):
            if (col, row) == head_pos:
                print("H", end="")
            elif (col, row) == tail_pos:
                print("T", end="")
            elif (col, row) == (0, 0):
                print("s", end="")
            elif (col, row) in positions:
                print("#", end="")
            elif (col, row) in knots:
                print(knots.index((col, row)) + 1, end="")
            else:
                print(".", end="")
        print()


def next_step(head, tail):
    neg_tail = [-1 * i for i in tail]
    diff = tuple([sum(i) for i in zip(head, neg_tail)])
    return {
        (0, 2): (0, 1),  # head is two above => move tail 1 up
        (0, -2): (0, -1),  # D
        (-2, 0): (-1, 0),  # L
        (2, 0): (1, 0),  # R
        (-2, 2): (-1, 1),  # UL
        (2, 2): (1, 1),  # UR
        (-2, -2): (-1, -1),  # DL
        (2, -2): (1, -1),  # DR
        (-1, 2): (-1, 1),  # DR
        (1, 2): (1, 1),  # DR
        (-2, 1): (-1, 1),  # DR
        (2, 1): (1, 1),  # DR
        (-1, -2): (-1, -1),  # DR
        (1, -2): (1, -1),  # DR
        (-2, -1): (-1, -1),  # DR
        (2, -1): (1, -1),  # DR
    }.get(diff, (0, 0))


def simulate(puzzle_input: str, additional_knots):
    if DEBUG:
        print()
    movements = puzzle_input.strip().splitlines()
    movements = [movement.split(" ") for movement in movements]
    movements = [(d, int(a)) for d, a in movements]

    head_pos = (0, 0)
    tail_pos = (0, 0)
    positions = set()

    positions.add(tail_pos)

    knots = [
        (0, 0),
    ] * additional_knots

    if DEBUG:
        print(f"Starting head: {head_pos}")
        print(f"Starting tail: {tail_pos}")
        print_grid(positions, head_pos, knots, tail_pos)

    for direction, movement in movements:
        direction = {
            "R": (1, 0),
            "U": (0, 1),
            "L": (-1, 0),
            "D": (0, -1),
        }[direction]
        moved = 0
        while moved < movement:
            if DEBUG:
                print(f"{direction=} * {movement}")
            head_pos = tuple([sum(i) for i in zip(head_pos, direction)])
            if DEBUG:
                print(f"{head_pos=}")
            moved += 1
            curr = head_pos
            for i in range(len(knots)):
                d = next_step(curr, knots[i])
                knots[i] = tuple([sum(i) for i in zip(knots[i], d)])
                curr = knots[i]
            response = next_step(curr, tail_pos)
            tail_pos = tuple([sum(i) for i in zip(tail_pos, response)])
            if DEBUG:
                print(f"{knots=}")
                print(f"{tail_pos=}")
            positions.add(tail_pos)
            # UL . UU . UR
            # .  . .  . .
            # LL . H  . RR
            # .  . .  . .
            # DL . DD . DR
            if DEBUG:
                print_grid(positions, head_pos, knots, tail_pos)

    if DEBUG:
        print_grid(positions, head_pos, knots, tail_pos)

    # ..##..
    # ...##.
    # .####.
    # ....#.
    # s###..

    return len(positions)


def part_one(puzzle_input: str):
    return simulate(puzzle_input, 0)


def part_two(puzzle_input: str):
    return simulate(puzzle_input, 8)
