const std = @import("std");
const utils = @import("../utils.zig");

const INPUT_FILE = "01.txt";

fn calc(first: u8, second: ?u8) u8 {
    var sum: u8 = 0;
    sum += first * 10;
    if (second) |s| {
        sum += s;
    } else {
        sum += first;
    }
    return sum;
}

fn partOne(allocator: std.mem.Allocator, contents: []const u8) ![]const u8 {
    var sum: u64 = 0;
    var first: ?u8 = null;
    var last: ?u8 = null;

    for (contents) |single_char| {
        if (single_char == "\n"[0]) {
            sum += calc(first orelse 0, last);
            first = null;
            last = null;
        }

        if (single_char >= 48 and single_char < 58) {
            const maybe_next: u8 = single_char - 48;
            if (first == null) {
                first = maybe_next;
            } else {
                last = maybe_next;
            }
        }
    }

    if (first) |f| {
        sum += calc(f, last);
    }

    return try std.fmt.allocPrint(allocator, "{d}", .{sum});
}

fn partTwo(allocator: std.mem.Allocator, contents: []const u8) ![]const u8 {
    var new: []u8 = try allocator.alloc(u8, contents.len);
    var i: u64 = 0;
    var j: u64 = 0;

    while (i < contents.len) {
        switch (contents[i]) {
            'o' => {
                // std.debug.print("one '{s}'", .{contents[i .. i + 3]});
                if (i + 3 < contents.len and std.mem.eql(u8, "one", contents[i .. i + 3])) {
                    // std.debug.print("\none found", .{});
                    // std.debug.print("\nset new[{}] = 1, contents[{}..{}] is {s}", .{ j, i, i + 3, contents[i .. i + 3] });
                    new[j] = 1 + 48;
                    i += 3;
                    j += 1;
                } else {
                    new[j] = contents[i];
                    i += 1;
                    j += 1;
                }
            },
            'n' => {
                // std.debug.print("nine '{s}'", .{contents[i .. i + 4]});
                if (i + 4 < contents.len and std.mem.eql(u8, "nine", contents[i .. i + 4])) {
                    // std.debug.print("\nnine found", .{});
                    // std.debug.print("\nset new[{}] = 9, contents[{}..{}] is {s}", .{ j, i, i + 4, contents[i .. i + 4] });
                    new[j] = 9 + 48;
                    i += 4;
                    j += 1;
                } else {
                    new[j] = contents[i];
                    i += 1;
                    j += 1;
                }
            },
            'e' => {
                // std.debug.print("eight '{s}'", .{contents[i .. i + 5]});
                if (i + 5 < contents.len and std.mem.eql(u8, "eight", contents[i .. i + 5])) {
                    // std.debug.print("\neight found", .{});
                    // std.debug.print("\nset new[{}] = 8, contents[{}..{}] is {s}", .{ j, i, i + 5, contents[i .. i + 5] });
                    new[j] = 8 + 48;
                    i += 5;
                    j += 1;
                } else {
                    new[j] = contents[i];
                    i += 1;
                    j += 1;
                }
            },
            't' => {
                // std.debug.print("two/three '{s}'", .{contents[i .. i + 3]});
                if (i + 3 < contents.len and std.mem.eql(u8, "two", contents[i .. i + 3])) {
                    // std.debug.print("\ntwo found", .{});
                    // std.debug.print("\nset new[{}] = 2, contents[{}..{}] is {s}", .{ j, i, i + 3, contents[i .. i + 3] });
                    new[j] = 2 + 48;
                    i += 3;
                    j += 1;
                } else if (i + 5 < contents.len and std.mem.eql(u8, "three", contents[i .. i + 5])) {
                    // std.debug.print("\nthree found", .{});
                    // std.debug.print("\nset new[{}] = 3, contents[{}..{}] is {s}", .{ j, i, i + 5, contents[i .. i + 5] });
                    new[j] = 3 + 48;
                    i += 5;
                    j += 1;
                } else {
                    new[j] = contents[i];
                    i += 1;
                    j += 1;
                }
            },
            'f' => {
                // std.debug.print("four/five '{s}'", .{contents[i .. i + 4]});
                if (i + 4 < contents.len and std.mem.eql(u8, "four", contents[i .. i + 4])) {
                    // std.debug.print("\nfour found", .{});
                    // std.debug.print("\nset new[{}] = 4, contents[{}..{}] is {s}", .{ j, i, i + 4, contents[i .. i + 4] });
                    new[j] = 4 + 48;
                    i += 4;
                    j += 1;
                } else if (i + 4 < contents.len and std.mem.eql(u8, "five", contents[i .. i + 4])) {
                    // std.debug.print("\nfive found", .{});
                    // std.debug.print("\nset new[{}] = 5, contents[{}..{}] is {s}", .{ j, i, i + 4, contents[i .. i + 4] });
                    new[j] = 5 + 48;
                    i += 4;
                    j += 1;
                } else {
                    new[j] = contents[i];
                    i += 1;
                    j += 1;
                }
            },
            's' => {
                // std.debug.print("six/seven '{s}'", .{contents[i .. i + 3]});
                if (i + 3 < contents.len and std.mem.eql(u8, "six", contents[i .. i + 3])) {
                    // std.debug.print("\nsix found", .{});
                    // std.debug.print("\nset new[{}] = 6, contents[{}..{}] is {s}", .{ j, i, i + 3, contents[i .. i + 3] });
                    new[j] = 6 + 48;
                    i += 3;
                    j += 1;
                } else if (i + 5 < contents.len and std.mem.eql(u8, "seven", contents[i .. i + 5])) {
                    // std.debug.print("\nseven found", .{});
                    // std.debug.print("\nset new[{}] = 7, contents[{}..{}] is {s}", .{ j, i, i + 5, contents[i .. i + 5] });
                    new[j] = 7 + 48;
                    i += 5;
                    j += 1;
                } else {
                    new[j] = contents[i];
                    i += 1;
                    j += 1;
                }
            },
            else => {
                // std.debug.print("\nset new[{}] = contents[{}] = {s}", .{ j, i, [1]u8{contents[i]} });
                new[j] = contents[i];
                i += 1;
                j += 1;
            },
        }
    }

    // std.debug.print("\n---------\n{s}\n----------\n", .{new[0..]});

    return try partOne(allocator, new);
}

test "day 1, part 1 [example]" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    var input =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;

    const actual = try partOne(allocator, input);
    try std.testing.expectEqualStrings("142", actual);
}

test "day 1, part 1" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const input: []const u8 = try utils.loadFileContents(allocator, INPUT_FILE);
    const response = try partOne(allocator, input);
    try utils.write("day 1, part 1", response);
}

test "day 1, part 2 [example]" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const input =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;

    const actual = try partTwo(allocator, input);
    try std.testing.expectEqualStrings("281", actual);
}

test "day 1, part 2" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const input: []const u8 = try utils.loadFileContents(allocator, INPUT_FILE);
    const response = try partTwo(allocator, input);
    try utils.write("day 1, part 2", response);
}
