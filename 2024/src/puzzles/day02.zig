const std = @import("std");
const utils = @import("../utils.zig");

const INPUT_FILE = "02.txt";

fn partOne(allocator: std.mem.Allocator, contents: []const u8) ![]const u8 {
    std.debug.print("\n", .{});
    const rgb = [_]i64{ 12, 13, 14 };
    var sum: i64 = 0;
    var lineIter = std.mem.split(u8, contents, "\n");
    while (lineIter.next()) |line| {
        var curr = [_]i64{ 0, 0, 0 };
        var colonIter = std.mem.split(u8, line, ":");
        var gameId = colonIter.first();
        if (gameId.len > 5) {
            const id = try utils.toI64(gameId[5..]);
            var grabsIter = std.mem.split(u8, colonIter.next().?, ";");
            while (grabsIter.next()) |grab| {
                var diceIter = std.mem.split(u8, grab, ",");
                while (diceIter.next()) |dice| {
                    if (std.mem.endsWith(u8, dice, "red")) {
                        // std.debug.print("\n'{s}'", .{dice[1 .. dice.len - 4]});
                        curr[0] = @max(curr[0], try utils.toI64(dice[1 .. dice.len - 4]));
                    } else if (std.mem.endsWith(u8, dice, "blue")) {
                        // std.debug.print("\n'{s}'", .{dice[1 .. dice.len - 5]});
                        curr[2] = @max(curr[2], try utils.toI64(dice[1 .. dice.len - 5]));
                    } else if (std.mem.endsWith(u8, dice, "green")) {
                        // std.debug.print("\n'{s}'", .{dice[1 .. dice.len - 6]});
                        curr[1] = @max(curr[1], try utils.toI64(dice[1 .. dice.len - 6]));
                    }
                }
            }
            if (curr[0] <= rgb[0] and curr[1] <= rgb[1] and curr[2] <= rgb[2]) {
                std.debug.print("\nG{}: r{}, g{}, b{} | r{}, g{}, b{}", .{ id, curr[0], curr[1], curr[2], rgb[0], rgb[1], rgb[2] });
                sum += id;
            }
        }
    }
    std.debug.print("\n\n", .{});
    return try std.fmt.allocPrint(allocator, "{d}", .{sum});
}

fn partTwo(allocator: std.mem.Allocator, contents: []const u8) ![]const u8 {
    std.debug.print("\n", .{});
    const rgb = [_]i64{ 12, 13, 14 };
    _ = rgb;
    var sum: i64 = 0;
    var lineIter = std.mem.split(u8, contents, "\n");
    while (lineIter.next()) |line| {
        var curr = [_]i64{ 0, 0, 0 };
        var colonIter = std.mem.split(u8, line, ":");
        var gameId = colonIter.first();
        if (gameId.len > 5) {
            const id = try utils.toI64(gameId[5..]);
            var grabsIter = std.mem.split(u8, colonIter.next().?, ";");
            while (grabsIter.next()) |grab| {
                var diceIter = std.mem.split(u8, grab, ",");
                while (diceIter.next()) |dice| {
                    if (std.mem.endsWith(u8, dice, "red")) {
                        // std.debug.print("\n'{s}'", .{dice[1 .. dice.len - 4]});
                        curr[0] = @max(curr[0], try utils.toI64(dice[1 .. dice.len - 4]));
                    } else if (std.mem.endsWith(u8, dice, "blue")) {
                        // std.debug.print("\n'{s}'", .{dice[1 .. dice.len - 5]});
                        curr[2] = @max(curr[2], try utils.toI64(dice[1 .. dice.len - 5]));
                    } else if (std.mem.endsWith(u8, dice, "green")) {
                        // std.debug.print("\n'{s}'", .{dice[1 .. dice.len - 6]});
                        curr[1] = @max(curr[1], try utils.toI64(dice[1 .. dice.len - 6]));
                    }
                }
            }

            const mul: i64 = (curr[0] * curr[1] * curr[2]);
            std.debug.print("\nG{}: r{}, g{}, b{} | m{}", .{ id, curr[0], curr[1], curr[2], mul });
            sum += mul;
        }
    }
    std.debug.print("\n\n", .{});
    return try std.fmt.allocPrint(allocator, "{d}", .{sum});
}

test "day 2, part 1 [example]" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    var input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;

    const actual = try partOne(allocator, input);
    try std.testing.expectEqualStrings("8", actual);
}

test "day 2, part 1" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const input: []const u8 = try utils.loadFileContents(allocator, INPUT_FILE);
    const response = try partOne(allocator, input);
    try utils.write("day 2, part 1", response);
}

test "day 2, part 2 [example]" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    var input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;

    const actual = try partTwo(allocator, input);
    try std.testing.expectEqualStrings("2286", actual);
}

test "day 2, part 2" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    const input: []const u8 = try utils.loadFileContents(allocator, INPUT_FILE);
    const response = try partTwo(allocator, input);
    try utils.write("day 2, part 2", response);
}
