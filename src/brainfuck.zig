const std = @import("std");

pub fn Brainfuck(
    comptime T: type,
    comptime tape_size: u32,
) type {
    return struct {
        const Self = @This();

        tape: [tape_size]T = [_]T{0} ** tape_size,

        pub fn run(self: *Self) void {
            return self;
        }
        pub fn init(self: *Self) void {
            self.tape[0] = 1;
        }
    };
}
