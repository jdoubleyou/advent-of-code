import functools
import typing as t

DEBUG = False


def check_LOS_from_bottom(grid, target_row, target_col):
    r = target_row + 1
    seen_trees = 0
    while r < len(grid):
        seen_trees += 1
        if DEBUG:
            print(f"BOTTOM grid[{r}][{target_col}]={int(grid[r][target_col])}")
        if int(grid[target_row][target_col]) <= int(grid[r][target_col]):
            return True, seen_trees
        r += 1
    return False, seen_trees


def check_LOS_from_top(grid, target_row, target_col):
    r = target_row - 1
    seen_trees = 0
    while r >= 0:
        seen_trees += 1
        if DEBUG:
            print(f"TOP: grid[{r}][{target_col}]={int(grid[r][target_col])}")
        if int(grid[target_row][target_col]) <= int(grid[r][target_col]):
            return True, seen_trees
        r -= 1
    return False, seen_trees


def check_LOS_from_right(grid, target_row, target_col):
    c = target_col + 1
    seen_trees = 0
    while c < len(grid[target_row]):
        seen_trees += 1
        if DEBUG:
            print(f"RIGHT grid[{target_row}][{c}]={grid[target_row][c]}")
        if int(grid[target_row][target_col]) <= int(grid[target_row][c]):
            return True, seen_trees
        c += 1
    return False, seen_trees


def check_LOS_from_left(grid, target_row, target_col):
    c = target_col - 1
    seen_trees = 0
    while c >= 0:
        seen_trees += 1
        if DEBUG:
            print(f"LEFT grid[{target_row}][{c}]={grid[target_row][c]}")
        if int(grid[target_row][target_col]) <= int(grid[target_row][c]):
            return True, seen_trees
        c -= 1
    return False, seen_trees


def calculate(puzzle_input: str):
    grid = puzzle_input.strip().splitlines()
    if DEBUG:
        print()
    total_hidden = 0
    new_grid = []
    score_grid = []
    max_score = 0
    for row in range(1, len(grid) - 1):
        new_row = ""
        score_row = ""
        for col in range(1, len(grid[row]) - 1):
            directions = [
                check_LOS_from_top(grid, row, col),
                check_LOS_from_right(grid, row, col),
                check_LOS_from_bottom(grid, row, col),
                check_LOS_from_left(grid, row, col),
            ]
            print_directions = [
                "HIDDEN" if direction else "VISIBLE" for direction in directions
            ]
            if DEBUG:
                print(
                    grid[row][col],
                    f"TOP:{print_directions[0]}, RIGHT:{print_directions[1]}, BOTTOM:{print_directions[2]}, LEFT:{print_directions[3]}",
                )
            hidden = functools.reduce(
                lambda accum, next: accum and next[0], directions, True
            )
            score = functools.reduce(lambda accum, next: accum * next[1], directions, 1)
            if hidden:
                total_hidden += 1
                new_row += "H"
            else:
                new_row += "V"
            score_row += f"{score}"
            if DEBUG:
                print(f"{score=}")

            if int(score) > max_score:
                if DEBUG:
                    print(f"Updating max score from {max_score} to {score}")
                max_score = score
        new_grid.append(new_row)
        score_grid.append(score_row)
    if DEBUG:
        print()
        print("new grid:")
        print("\n".join(new_grid))
        print()
        print("score grid:")
        print("\n".join(score_grid))
    return ((len(grid) * len(grid[0])) - total_hidden), max_score


def part_one(puzzle_input: str):
    return calculate(puzzle_input)[0]


def part_two(puzzle_input: str):
    return calculate(puzzle_input)[1]
