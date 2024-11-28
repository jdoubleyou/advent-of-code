def part_one(puzzle_input: str):
    pairs = puzzle_input.strip().split("\n")
    return sum(
        [
            1
            if (
                s := [
                    set(range(*[int(e) + i for i, e in enumerate(p.split("-"))]))
                    for p in pair.split(",")
                ],
            )
            and (s[0].issubset(s[1]) or s[1].issubset(s[0]))
            else 0
            for pair in pairs
        ]
    )


def part_two(puzzle_input: str):
    pairs = puzzle_input.strip().split("\n")
    return sum(
        [
            1
            if (
                s := [
                    set(range(*[int(e) + i for i, e in enumerate(p.split("-"))]))
                    for p in pair.split(",")
                ],
            )
            and not s[0].isdisjoint(s[1])
            else 0
            for pair in pairs
        ]
    )
