const std = @import("std");
const utils = @import("../utils.zig");

const INPUT_FILE = "03.txt";
const DEBUG = false;
const INFO = true;

fn isNum(char: u8) bool {
    return char > 47 and char < 58;
}

fn printDebug(comptime fmt: []const u8, args: anytype) void {
    if (DEBUG) {
        std.debug.print(fmt, args);
    }
}
fn printInfo(comptime fmt: []const u8, args: anytype) void {
    if (INFO) {
        std.debug.print(fmt, args);
    }
}
fn print(comptime fmt: []const u8, args: anytype) void {
    std.debug.print(fmt, args);
}

fn partOne(allocator: std.mem.Allocator, contents: []const u8) ![]const u8 {
    var lineIter = std.mem.split(u8, contents, "\n");

    const Location = struct {
        x_start: u64 = 0,
        x_end: u64 = 0,
        line: u64,
        line_len: u64,
        line_start: u64,
        content: [5]u8 = [_]u8{ 0, 0, 0, 0, 0 },
        used: u64 = 0,
        is_num: bool,
    };

    const numbers = try allocator.alloc(Location, contents.len);
    defer allocator.free(numbers);
    const symbols = try allocator.alloc(Location, contents.len);
    defer allocator.free(symbols);

    printInfo("\n\n+++++++++++++++\n", .{});
    var line_num: u64 = 0;
    var numbers_found: u64 = 0;
    var symbols_found: u64 = 0;
    var chars_accum: u64 = 0;
    var total_lines: u64 = 0;
    while (lineIter.next()) |line| : (line_num += 1) {
        printInfo("{d:0>3}|{s}|\n", .{ line_num, line });
        // keep track of everything that is not a period.
        var started = false;
        var current_location: Location = .{
            .is_num = false,
            .line = line_num,
            .line_len = line.len + 1, // the extra newline that exists in contents to delineate lines
            .line_start = chars_accum,
        };
        var last_i: u64 = 0;
        for (line, 0..) |char, i| {
            last_i = i;
            if (!started) {
                if (char != '.') {
                    started = true;
                    current_location.is_num = isNum(char);
                    current_location.x_start = i;
                    current_location.line = line_num;
                    current_location.content = [_]u8{ 0, 0, 0, 0, 0 };
                    current_location.content[0] = char;
                    current_location.used = 1;
                } else continue;
            } else {
                if (char == '.') {
                    started = false;
                    // check to make sure slice doesn't include this
                    current_location.x_end = i;
                    printDebug(" ==> ({}..{}, {}) = {s} ({s}) ({}..{}) is_num={s}\n", .{
                        current_location.x_start,
                        current_location.x_end,
                        current_location.line,
                        current_location.content[0..current_location.used],
                        line[current_location.x_start..current_location.x_end],
                        current_location.line_start,
                        current_location.line_len + current_location.line_start,
                        if (current_location.is_num) "T" else "F",
                    });
                    if (current_location.is_num) {
                        numbers[numbers_found] = current_location;
                        numbers_found += 1;
                    } else {
                        symbols[numbers_found] = current_location;
                        symbols_found += 1;
                    }
                    current_location = .{
                        .is_num = false,
                        .line = line_num,
                        .line_len = line.len + 1, // the extra newline that exists in contents to delineate lines
                        .line_start = chars_accum,
                    };
                } else if (isNum(char) != current_location.is_num) {
                    // changed from one to other
                    // check to make sure slice doesn't include this
                    current_location.x_end = i;
                    printDebug(" =>> ({}..{}, {}) = {s} ({s}) ({}..{}) is_num={s}\n", .{
                        current_location.x_start,
                        current_location.x_end,
                        current_location.line,
                        current_location.content[0..current_location.used],
                        line[current_location.x_start..current_location.x_end],
                        current_location.line_start,
                        current_location.line_len + current_location.line_start,
                        if (current_location.is_num) "T" else "F",
                    });
                    if (current_location.is_num) {
                        numbers[numbers_found] = current_location;
                        numbers_found += 1;
                    } else {
                        symbols[numbers_found] = current_location;
                        symbols_found += 1;
                    }

                    current_location.is_num = isNum(char);
                    current_location.x_start = i;
                    current_location.line = line_num;
                    current_location.content = [_]u8{ 0, 0, 0, 0, 0 };
                    current_location.content[0] = char;
                    current_location.used = 1;
                } else {
                    current_location.content[current_location.used] = char;
                    current_location.used += 1;
                }
            }
        }

        if (started) {
            current_location.x_end = last_i + 1;
            printDebug(" >>> ({}..{}, {}) = {s} ({s}) ({}..{}) is_num={s}\n", .{
                current_location.x_start,
                current_location.x_end,
                current_location.line,
                current_location.content[0..current_location.used],
                line[current_location.x_start..current_location.x_end],
                current_location.line_start,
                current_location.line_len + current_location.line_start,
                if (current_location.is_num) "T" else "F",
            });
            if (current_location.is_num) {
                numbers[numbers_found] = current_location;
                numbers_found += 1;
            } else {
                symbols[numbers_found] = current_location;
                symbols_found += 1;
            }
        }

        chars_accum += line.len + 1;
        total_lines += 1;
    }
    printInfo("+++++++++++++++\n\n", .{});
    printInfo("\nNumbers found: {}\nSymbols found: {}\n", .{ numbers_found, symbols_found });
    printInfo("~~~~~~~~~~~~~~~\n\n", .{});

    var total_sum: u64 = 0;

    for (0..numbers_found) |curr| {
        const location: Location = numbers[curr];
        var has_front = false;
        var has_back = false;

        printInfo("checking '{s}'\n", .{location.content});

        if (location.x_start != 0) {
            has_front = true;
            const front = contents[location.line_start + location.x_start - 1];
            printInfo("checking fro '{s}' for '{s}'\n", .{ ([_]u8{front})[0..], location.content });
            if (front != '.' and !isNum(front)) {
                total_sum += try std.fmt.parseInt(u64, location.content[0..(location.x_end - location.x_start)], 10);
                printInfo("'{s}' counts\n", .{location.content[0..(location.x_end - location.x_start)]});
                continue;
            }
        }

        if (location.x_end != location.line_len - 1) {
            has_back = true;
            const back = contents[location.line_start + location.x_end];
            printInfo("checking bac '{s}' for '{s}'\n", .{ ([_]u8{back})[0..], location.content });
            if (back != '.' and !isNum(back)) {
                total_sum += try std.fmt.parseInt(u64, location.content[0..(location.x_end - location.x_start)], 10);
                printInfo("'{s}' counts\n", .{location.content[0..(location.x_end - location.x_start)]});
                continue;
            }
        }

        var accounted_for = false;

        if (location.line != 0) {
            // relies on all lines being the same, which originally the rest of the code didn't care about
            const f: u64 = if (has_front) 1 else 0;
            const b: u64 = if (has_back) 1 else 0;
            const start = (location.line_len * (location.line - 1)) + location.x_start - f;
            const end = (location.line_len * (location.line - 1)) + location.x_end + b;
            const top = contents[start..end];
            printInfo("checking top '{s}' for '{s}'\n", .{ top, location.content });
            for (top) |t| {
                if (t != '.' and !isNum(t)) {
                    total_sum += try std.fmt.parseInt(u64, location.content[0..(location.x_end - location.x_start)], 10);
                    accounted_for = true;
                    printInfo("'{s}' counts\n", .{location.content[0..(location.x_end - location.x_start)]});
                    break;
                }
            }
        }

        if (accounted_for) continue;

        if (location.line != total_lines - 1) {
            const f: u64 = if (has_front) 1 else 0;
            const bb: u64 = if (has_back) 1 else 0;
            const start = (location.line_len * (location.line + 1)) + location.x_start - f;
            const end = (location.line_len * (location.line + 1)) + location.x_end + bb;
            const bottom = contents[start..end];
            printInfo("checking bot '{s}' for '{s}'\n", .{ bottom, location.content });
            for (bottom) |b| {
                if (b != '.' and !isNum(b)) {
                    total_sum += try std.fmt.parseInt(u64, location.content[0..(location.x_end - location.x_start)], 10);
                    printInfo("'{s}' counts\n", .{location.content[0..(location.x_end - location.x_start)]});
                    break;
                }
            }
        }
    }

    // need to know where each number lies in the plane [(x0, x1), y]
    // check the following places
    // [x0-1, y] front
    // [x1+1, y] back
    // [(x0-1)..(x1+1), y+1] each top
    // [(x0-1)..(x1+1), y-1] each bottom

    // slice by lines
    // short circuit when able
    // ensure x and y do not go out of bounds

    // example
    //467..114..
    //...*......
    //..35..633.
    //......#...
    //617*......
    //.....+.58.
    //..592.....
    //......755.
    //...$.*....
    //.664.598..

    printInfo("~~~~~~~~~~~~~~~\n\n", .{});
    print("total: {}\n\n", .{total_sum});
    return std.fmt.allocPrint(allocator, "{}", .{total_sum});
}

fn partTwo(allocator: std.mem.Allocator, contents: []const u8) ![]const u8 {
    _ = allocator;
    const Pos = struct {};
    _ = Pos;
    // var positions = try allocator.alloc(Pos, contents.len);
    // _ = positions;
    printInfo("\n", .{});

    const line_len: usize = std.mem.indexOf(u8, contents, "\n").? + 1;
    const line_total: usize = @divTrunc(contents.len, line_len);
    for (contents, 0..) |char, index| {
        const line_pos: usize = @mod(index, line_len);
        const line: usize = @divTrunc(index, line_len);
        const line_start: usize = line * line_len;
        const line_end: usize = (line * line_len) + line_len;
        if (char == '*') {
            printInfo("S: index{}, pos{}, line{}, lstart{}, lend{}\n", .{ index, line_pos, line, line_start, line_end });
            var front = index - 1;
            var back = index + 1;
            printInfo("M: [{}, {}]\n", .{ front, back });
            var top_front: ?u64 = null;
            var top_back: ?u64 = null;
            var bottom_front: ?u64 = null;
            var bottom_back: ?u64 = null;
            while (contents[front] != '.' and contents[front] != '\n' and front > line_start) : (front -= 1) {}
            while (contents[back] != '.' and contents[back] != '\n' and back < line_end) : (back += 1) {}

            if (line > 0) {
                top_front = (((line - 1) * line_len) + line_pos) - 1;
                top_back = (((line - 1) * line_len) + line_pos) + 1;
                printInfo("T: [{}, {}]\n", .{ top_front.?, top_back.? });
                while (contents[top_front.?] != '.' and contents[top_front.?] != '\n' and top_front.? > ((line - 1) * line_len)) : (top_front.? -= 1) {}
                while (contents[top_back.?] != '.' and contents[top_back.?] != '\n' and top_back.? < (((line - 1) * line_len) + line_len)) : (top_back.? += 1) {}
            }

            if (line < line_total) {
                bottom_front = (((line + 1) * line_len) + line_pos) - 1;
                bottom_back = (((line + 1) * line_len) + line_pos) + 1;
                printInfo("B: [{}, {}]\n", .{ bottom_front.?, bottom_back.? });
                while (contents[bottom_front.?] != '.' and contents[bottom_front.?] != '\n' and bottom_front.? > ((line + 1) * line_len)) : (bottom_front.? -= 1) {}
                while (contents[bottom_back.?] != '.' and contents[bottom_back.?] != '\n' and bottom_back.? < (((line + 1) * line_len) + line_len)) : (bottom_back.? += 1) {}
            }

            printInfo("\n---------\n", .{});
            if (top_front != null) {
                printInfo("TOP: {s} [{}, {}]\n", .{ contents[top_front.?..top_back.?], top_front.?, top_back.? });
            }
            printInfo("MID: {s} [{}, {}]\n", .{ contents[front..back], front, back });
            if (bottom_front != null) {
                printInfo("BOT: {s} [{}, {}]\n", .{ contents[bottom_front.?..bottom_back.?], bottom_front.?, bottom_back.? });
            }
            printInfo("---------\n\n", .{});
        }
    }
    // get line length
    // loop through contents
    // if char is '*', check the surrounding 8 positions
    // if total adjacent is exactly 2, then add position to list
    // for each position that has two numbers get those numbers
    // multiply together
    // add to sum
    return "CHANGE_ME";
}

// test "day 3, part 1 [example]" {
//     var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
//     const allocator = arena.allocator();
//     defer arena.deinit();

//     var input =
//         \\467..114..
//         \\...*......
//         \\..35..633.
//         \\......#...
//         \\617*......
//         \\.....+.58.
//         \\..592.....
//         \\.......755
//         \\...$.*....
//         \\.664.598..
//     ;

//     const actual = try partOne(allocator, input);
//     try std.testing.expectEqualStrings("3606", actual);
// }

// test "day 3, part 1 [example2]" {
//     var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
//     const allocator = arena.allocator();
//     defer arena.deinit();

//     var input =
//         \\467..114..
//         \\...*......
//         \\..35..633.
//         \\......#...
//         \\617*......
//         \\.....+.58.
//         \\..592.....
//         \\......755.
//         \\...$.*....
//         \\.664.598..
//     ;

//     const actual = try partOne(allocator, input);
//     try std.testing.expectEqualStrings("4361", actual);
// }

// test "day 3, part 1" {
//     var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
//     const allocator = arena.allocator();
//     defer arena.deinit();

//     const input: []const u8 = try utils.loadFileContents(allocator, INPUT_FILE);
//     const response = try partOne(allocator, input);
//     try utils.write("day 3, part 1", response);
// }

test "day 3, part 2 [example]" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    var input =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;

    const actual = try partTwo(allocator, input);
    try std.testing.expectEqualStrings("CHANGE_ME", actual); // 467835
}

// test "day 3, part 2" {
//     var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
//     const allocator = arena.allocator();
//     defer arena.deinit();

//     const input: []const u8 = try utils.loadFileContents(allocator, INPUT_FILE);
//     const response = try partTwo(allocator, input);
//     try utils.write("day 3, part 2", response);
// }
