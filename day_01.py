""" Advent of Code 2020 - Day 1 """


def read_file():
    v = []
    with open('files/day_1_input.txt') as f:
        lines = f.read().splitlines()
    for x in lines:
        v.append(int(x))
    return v


def part_1(values):
    for x in values:
        for y in values:
            if 2020 == x + y:
                return x * y


def part_2(values):
    for x in values:
        for y in values:
            for z in values:
                if 2020 == x + y + z:
                    return x * y * z


values = read_file()
print(part_1(values))
print(part_2(values))
