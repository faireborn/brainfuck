const std = @import("std");
const c = @import("c.zig").c;

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
        ip: u32,
        commands: []u8,

        const Self = @This();

        pub fn set(self: *Self, commands: []u8) void {
            self.head = 0;
            self.tape = [_]T{0} ** tape_size;
            self.ip = 0;
            self.commands = commands;
        }

        pub fn exe(self: *Self) BfError!void {
            while (self.ip < self.commands.len) {
                switch (self.commands[self.ip]) {
                    '+' => self.inc(),
                    '-' => self.dec(),
                    '>' => self.right(),
                    '<' => try self.left(),
                    '[' => {
                        self.open();
                        continue;
                    },
                    ']' => {
                        self.close();
                        continue;
                    },
                    '.' => self.output(),
                    ',' => self.input(),
                    ' ', '\n', '\r', '\t' => {},
                    else => {
                        std.log.err("Unknown command {}", .{self.head});
                        return error.UnknownCommand;
                    },
                }
                self.ip += 1;
            }
        }

        pub fn getTape(self: *Self) !void {
            std.debug.print("tape: {any}\n", .{&self.tape});
        }

        pub fn getCommands(self: *Self) !void {
            std.debug.print("{s}\n", .{self.commands});
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

        fn open(self: *Self) void {
            if (self.tape[self.head] != 0) {
                self.ip += 1;
                return;
            }

            var acc: u32 = 1;
            while (acc != 0) {
                self.ip += 1;

                switch (self.commands[self.ip]) {
                    '[' => acc += 1,
                    ']' => acc -= 1,
                    else => {},
                }
            }
        }

        fn close(self: *Self) void {
            if (self.tape[self.head] == 0) {
                self.ip += 1;
                return;
            }

            var acc: u32 = 1;
            while (acc != 0) {
                self.ip -= 1;
                switch (self.commands[self.ip]) {
                    '[' => acc -= 1,
                    ']' => acc += 1,
                    else => {},
                }
            }
        }

        fn output(self: *Self) void {
            _ = c.putchar(self.tape[self.head]);
        }

        fn input(self: *Self) void {
            self.tape[self.head] = c.getchar();
        }
    };
}
