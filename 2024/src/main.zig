const std = @import("std");
const utils = @import("./utils.zig");

pub fn main() !void {
    var general_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = general_allocator.deinit();

    const allocator = general_allocator.allocator();
    var arena_instance = std.heap.ArenaAllocator.init(allocator);
    defer arena_instance.deinit();

    const arena = arena_instance.allocator();
    const args: [][]u8 = try std.process.argsAlloc(arena);

    if (args.len != 1) {
        std.log.err("Expected exactly one argument. Usage: zig run <day>", .{});
        return;
    }

    switch (!utils.toI64(args[0])) {
        1 => {},
    }

    for (args[1..]) |arg| {
        if (std.mem.eql(u8, arg, "-v")) {
            verbosity = @max(verbosity, 1);
        } else if (std.mem.eql(u8, arg, "-vv")) {
            verbosity = @max(verbosity, 2);
        } else if (std.mem.eql(u8, arg, "-vvv")) {
            verbosity = @max(verbosity, 3);
        } else if (std.mem.eql(u8, arg, "-vvvv")) {
            verbosity = @max(verbosity, 4);
        } else {
            return Error.UnknownArgumentGiven;
        }
    }
}

test {
    _ = @import("puzzles/day01.zig");
    _ = @import("puzzles/day02.zig");
    _ = @import("puzzles/day03.zig");
    _ = @import("puzzles/day04.zig");
    _ = @import("puzzles/day05.zig");
    _ = @import("puzzles/day06.zig");
    _ = @import("puzzles/day07.zig");
    _ = @import("puzzles/day08.zig");
    _ = @import("puzzles/day09.zig");
    _ = @import("puzzles/day10.zig");
    _ = @import("puzzles/day11.zig");
    _ = @import("puzzles/day12.zig");
    _ = @import("puzzles/day13.zig");
    _ = @import("puzzles/day14.zig");
    _ = @import("puzzles/day15.zig");
    _ = @import("puzzles/day16.zig");
    _ = @import("puzzles/day17.zig");
    _ = @import("puzzles/day18.zig");
    _ = @import("puzzles/day19.zig");
    _ = @import("puzzles/day20.zig");
    _ = @import("puzzles/day21.zig");
    _ = @import("puzzles/day22.zig");
    _ = @import("puzzles/day23.zig");
    _ = @import("puzzles/day24.zig");
    _ = @import("puzzles/day25.zig");
}
