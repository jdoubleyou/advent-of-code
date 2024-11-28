const std = @import("std");
const utils = @import("../utils.zig");

const INPUT_FILE = "06.txt";

fn partOne(allocator: std.mem.Allocator, contents: []const u8) ![]const u8 {
    _ = contents;
    _ = allocator;
    return "CHANGE_ME";
}

fn partTwo(allocator: std.mem.Allocator, contents: []const u8) ![]const u8 {
    _ = contents;
    _ = allocator;
    return "CHANGE_ME";
}

test "day 6, part 1 [example]" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    var input =
        \\
    ;

    const actual = try partOne(allocator, input);
    try std.testing.expectEqualStrings("CHANGE_ME", actual);
}

test "day 6, part 1" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const input: []const u8 = try utils.loadFileContents(allocator, INPUT_FILE);
    const response = try partOne(allocator, input);
    try utils.write("day 6, part 1", response);
}

test "day 6, part 2 [example]" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const input =
        \\
    ;

    const actual = try partTwo(allocator, input);
    try std.testing.expectEqualStrings("CHANGE_ME", actual);
}

test "day 6, part 2" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const input: []const u8 = try utils.loadFileContents(allocator, INPUT_FILE);
    const response = try partTwo(allocator, input);
    try utils.write("day 6, part 2", response);
}
