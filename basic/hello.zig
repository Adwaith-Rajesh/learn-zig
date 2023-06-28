const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;

pub fn main() void {
    const a = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
    print("Hello WOrld\n", .{});
    print("{s}\n", .{a});
}
