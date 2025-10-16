const std = @import("std");
const c = @import("c.zig").c;
const Allocator = std.mem.Allocator;
const Brainfuck = @import("brainfuck.zig").Brainfuck(i16, 30_000);

var brainfuck: Brainfuck = undefined;

pub fn main() void {
    main2() catch |err| {
        std.log.err("{}", .{err});
        c.abort();
    };
}

pub fn main2() !void {
    var general_purpose_allocator: std.heap.GeneralPurposeAllocator(.{}) = .init;
    const gpa = general_purpose_allocator.allocator();
    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    if (args.len != 2) {
        std.log.err("Usage: {s} file_name", .{args[0]});
        return error.UsageError;
    }

    const file_name = args[1];
    var file = try std.fs.cwd().openFile(file_name, .{});
    defer file.close();

    var file_buffer: [1024]u8 = undefined;
    var file_reader = file.reader(&file_buffer);

    const allocator = std.heap.page_allocator;
    const commands = try allocator.alloc(u8, 1024);
    defer allocator.free(commands);

    var tail: usize = 0;
    while (true) {
        if (file_reader.interface.takeDelimiter('\n')) |line| {
            if (line) |cur| {
                @memcpy(commands[tail .. tail + cur.len], cur);
                tail += cur.len;
            } else {
                break;
            }
        } else |err| {
            switch (err) {
                error.ReadFailed => std.log.err("Read Error", .{}),
                error.StreamTooLong => std.log.err("Stream Is Too Long!!", .{}),
            }
        }
    }

    const b = &brainfuck;
    b.set(commands[0..tail]);
    try b.exe();
}
