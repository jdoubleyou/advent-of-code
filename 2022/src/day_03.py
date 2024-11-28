from string import ascii_letters


def part_one(puzzle_input: str):
    rucksacks = puzzle_input.strip().split("\n")

    shared_values = []
    for rucksack in rucksacks:
        l = len(rucksack) // 2
        first, second = set(rucksack[:l]), set(rucksack[l:])
        shared = first.intersection(second)
        assert len(shared) == 1
        shared_values.append(ascii_letters.find(list(shared)[0]) + 1)
    return sum(shared_values)


def part_two(puzzle_input: str):
    rucksacks = puzzle_input.strip().split("\n")

    shared_values = []
    while rucksacks:
        first, second, third, *rucksacks = rucksacks
        shared = set(first).intersection(set(second)).intersection(set(third))
        assert len(shared) == 1
        shared_values.append(ascii_letters.find(list(shared)[0]) + 1)

    return sum(shared_values)
