const std = @import("std");
const c = @import("c.zig").c;
const Brainfuck = @import("brainfuck.zig").Brainfuck(u8, 30_000);

var brainfuck: Brainfuck = undefined;

pub fn main() void {
    main2() catch c.abort();
}

pub fn main2() !void {
    var general_purpose_allocator: std.heap.GeneralPurposeAllocator(.{}) = .init;
    const gpa = general_purpose_allocator.allocator();
    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    if (args.len != 2) {
        std.log.err("Usage: {s} file_name", .{args[0]});
        c.abort();
    }

    const file_name = args[1];
    var file = try std.fs.cwd().openFile(file_name, .{});
    defer file.close();

    var file_buffer: [1024]u8 = undefined;
    var file_reader = file.reader(&file_buffer);

    while (true) {
        if (file_reader.interface.takeDelimiter('\n')) |line| {
            if (line) |string| {
                std.debug.print("{s}", .{string});
            } else {
                break;
            }
        } else |err| {
            switch (err) {
                error.ReadFailed => std.log.err("{}", .{err}),
                error.StreamTooLong => std.log.err("{}", .{err}),
            }
        }
    }
    // while (file_reader.interface.takeDelimiterExclusive('\n')) |line| {
    //     std.debug.print("{s}", .{line});
    // }

    const b = &brainfuck;
    b.init();
}
