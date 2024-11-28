from typing import Callable


def get_size(
    parent_name: str,
    sizes: dict,
    big_dirs: list,
    all_dirs: list,
    predicate: Callable[[int], bool],
):
    total = 0
    for name, value in sizes.items():
        full_name = parent_name + "/" + name
        if type(value) == dict:
            dir_size = get_size(full_name, value, big_dirs, all_dirs, predicate)
            total += dir_size
            all_dirs.append((full_name, dir_size))
            if predicate(dir_size):
                big_dirs.append((full_name, dir_size))
        elif type(value) == int:
            total += value
    return total


def make_directory_tree(puzzle_input: str):
    dir_stack = []
    dir_sizes = {}
    lines = [line.strip() for line in puzzle_input.strip().splitlines()]
    for line in lines:
        if line.startswith("$ "):
            cmd = line.replace("$ ", "")
            if cmd.startswith("cd "):
                directory = cmd.split()[-1]
                if directory == "..":
                    dir_stack.pop()
                else:
                    curr = dir_sizes
                    for s in dir_stack:
                        curr = curr[s]
                    curr[directory] = curr.get(directory, {})
                    dir_stack.append(directory)
        else:
            if line.startswith("dir "):
                _, dir_name = line.split()
                curr = dir_sizes
                for s in dir_stack:
                    curr = curr[s]
                curr[dir_name] = curr.get(dir_name, {})
            else:
                size, file_name = line.split()
                size = int(size)
                curr = dir_sizes
                for s in dir_stack:
                    curr = curr[s]
                curr[file_name] = size
    return dir_sizes


def get_stats(puzzle_input: str):
    dir_sizes = make_directory_tree(puzzle_input)

    # what is this, C?
    big_dirs = []
    all_dirs = []
    total = get_size(
        "",
        dir_sizes["/"],
        big_dirs,
        all_dirs,
        lambda value: 0 < value <= 100000,
    )
    return (total, big_dirs, all_dirs)


def part_one(puzzle_input: str):
    _, big_dirs, _ = get_stats(puzzle_input)
    return sum([p[1] for p in big_dirs])


def part_two(puzzle_input: str):
    total, _, all_dirs = get_stats(puzzle_input)
    free_space = 70000000 - total
    needed_space = (
        30000000 - free_space
    )  # part two took so long because I thought they gave the value of needed_space in the problem so I hard coded 8 million... they did not :(
    all_dirs = [a[1] for a in all_dirs]
    all_dirs = list(filter(lambda v: v >= needed_space, all_dirs))
    return min(all_dirs)
