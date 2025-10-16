const std = @import("std");

const BfError = error{
    UnknownCommand,
    InvalidHead,
};

pub fn Brainfuck(
    comptime T: type,
    comptime tape_size: u32,
) type {
    return struct {
        head: u32,
        tape: [tape_size]T,
        commands: []u8,

        const Self = @This();

        pub fn set(self: *Self, commands: *const []u8) void {
            self.head = 0;
            self.tape = [_]T{0} ** tape_size;
            self.commands = commands;
        }

        pub fn exe(self: *Self) BfError!void {
            while (true) {
                switch (self.head) {
                    '+' => self.inc(),
                    '-' => self.dec(),
                    '>' => self.right(),
                    '<' => try self.left(),
                    else => {
                        std.log.err("Unknown command {c}", .{self.head});
                        return error.UnknownCommand;
                    },
                }
                self.head += 1;
            }
        }

        pub fn getTape(self: *Self) !void {
            std.debug.print("tape: {any}\n", .{&self.tape});
        }

        fn inc(self: *Self) void {
            self.tape[self.head] += 1;
        }
        fn dec(self: *Self) void {
            self.tape[self.head] -= 1;
        }
        fn right(self: *Self) void {
            self.head += 1;
        }
        fn left(self: *Self) BfError!void {
            if (self.head <= 0) {
                return error.InvalidHead;
            }
            self.head -= 1;
        }
        //fn input(self: *Self) void {}
        //fn output(self: *Self) void {}
    };
}
