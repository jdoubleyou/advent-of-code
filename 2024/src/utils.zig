const std = @import("std");

pub fn write(prefix: []const u8, contents: []const u8) !void {
    try std.io.getStdOut().writer().print("\nOutput ({s}):\n-----\n{s}\n-----\n", .{ prefix, contents });
}

pub fn loadFileContents(allocator: std.mem.Allocator, name: []const u8) anyerror![]u8 {
    var dir = try std.fs.cwd().openDir("data", .{});
    defer dir.close();

    var file = try dir.openFile(name, .{});
    defer file.close();

    return readAll(allocator, file);
}

fn readAll(allocator: std.mem.Allocator, file: std.fs.File) anyerror![]u8 {
    const file_size = try file.getEndPos();
    return try file.readToEndAlloc(allocator, file_size);
}

pub fn toI64(contents: []const u8) !i64 {
    return try std.fmt.parseInt(i64, contents, 10);
}
