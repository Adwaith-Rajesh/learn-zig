const std = @import("std");
const stdout = std.io.getStdOut().writer();

const Node = struct {
    data: i64,
    next: ?*Node,
};

fn createNode(data: i64, allocator: std.mem.Allocator) !*Node {
    var new_node = try allocator.create(Node);
    new_node.data = data;
    new_node.next = null;
    return new_node;
}

const LinkedList = struct {
    head: ?*Node = null,
    allocator: std.mem.Allocator,

    fn addNode(self: *LinkedList, data: i64) !void {
        var new_node = try createNode(data, self.allocator);
        if (self.head == null) {
            self.head = new_node;
            return;
        }
        var temp = self.head;
        while (temp.?.next != null) {
            temp = temp.?.next;
        }
        temp.?.next = new_node;
    }

    fn addLeft(self: *LinkedList, data: i64) !void {
        var new_node = try createNode(data, self.allocator);
        if (self.head == null) {
            self.head = new_node;
            return;
        }
        new_node.next = self.head;
        self.head = new_node;
    }

    fn display(self: LinkedList) !void {
        var temp = self.head;
        while (temp) |v| {
            try stdout.print("Node: {d}\n", .{v.data});
            temp = v.next;
        }
    }

    fn destroy(self: *LinkedList) !void {
        var temp: ?*Node = undefined;
        while (self.head) |v| {
            temp = self.head;
            self.head = v.next;
            self.allocator.destroy(temp.?);
        }
    }
};

pub fn main() !void {
    var allocator = std.heap.page_allocator;

    var list = LinkedList{
        .allocator = allocator,
    };
    try list.addNode(3);
    try list.addNode(4);
    try list.addLeft(5);
    try list.addLeft(6);
    try list.display();
    try list.destroy();

    try stdout.print("Hello World\n", .{});
}
