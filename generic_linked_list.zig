const std = @import("std");
const stdout = std.io.getStdOut().writer();

fn LinkedList(comptime T: type) type {
    return struct {
        const Self = @This();

        pub const Node = struct {
            data: T,
            next: ?*Node,
        };

        head: ?*Node = null,
        allocator: std.mem.Allocator,

        fn createNode(self: Self, data: T) !*Node {
            var new_node = try self.allocator.create(Node);
            new_node.data = data;
            new_node.next = null;
            return new_node;
        }

        pub fn push(self: *Self, data: T) !void {
            var new_node = try self.createNode(data);
            if (self.head == null) {
                self.head = new_node;
                return;
            }
            var temp: ?*Node = self.head;
            while (temp.?.next != null) {
                temp = temp.?.next;
            }
            temp.?.next = new_node;
        }

        pub fn display(self: Self) !void {
            var temp = self.head;
            while (temp) |v| {
                try stdout.print("Node: {?}\n", .{v.data});
                temp = v.next;
            }
        }

        pub fn destroy(self: *Self) void {
            var temp: ?*Node = undefined;
            while (self.head) |v| {
                temp = self.head;
                self.head = v.next;
                self.allocator.destroy(temp.?);
            }
        }
    };
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const L = LinkedList(i64);
    var list = L{ .allocator = allocator };
    try list.push(45);
    try list.push(45);
    try list.push(45);
    try list.push(45);
    try list.push(45);
    try list.push(45);
    try list.display();
    list.destroy();
}
