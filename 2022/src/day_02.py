rock = "A"
paper = "B"
scissors = "C"

conversions = {
    "X": rock,
    "Y": paper,
    "Z": scissors,
}

results = {
    rock + rock: 3,
    scissors + scissors: 3,
    paper + paper: 3,
    paper + rock: 0,
    rock + scissors: 0,
    scissors + paper: 0,
    scissors + rock: 6,
    paper + scissors: 6,
    rock + paper: 6,
}

score = {
    rock: 1,
    paper: 2,
    scissors: 3,
}


that_beats = {
    scissors: rock,
    rock: paper,
    paper: scissors,
}

that_loses_to = {
    rock: scissors,
    paper: rock,
    scissors: paper,
}


find_hand = {
    "X": lambda opp: that_loses_to[opp],
    "Y": lambda opp: opp,
    "Z": lambda opp: that_beats[opp],
}


def part_one(puzzle_input: str):
    hands = puzzle_input.strip().split("\n")
    hands = [tuple(hand.split()) for hand in hands]
    hands = [(opp + conversions[you], conversions[you]) for opp, you in hands]
    hands = [results[res] + score[play] for res, play in hands]
    return sum(hands)


def part_two(puzzle_input: str):
    hands = puzzle_input.strip().split("\n")
    hands = [tuple(hand.split()) for hand in hands]
    hands = [(opp + find_hand[you](opp), find_hand[you](opp)) for opp, you in hands]
    hands = [results[res] + score[play] for res, play in hands]
    return sum(hands)
