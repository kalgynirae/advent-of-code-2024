const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var list1 = std.ArrayList(u32).init(allocator);
    var list2 = std.ArrayList(u32).init(allocator);
    var buffer: [16]u8 = undefined;

    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var tokens = std.mem.tokenizeScalar(u8, line, ' ');
        try list1.append(try std.fmt.parseUnsigned(u32, tokens.next() orelse unreachable, 10));
        try list2.append(try std.fmt.parseUnsigned(u32, tokens.next() orelse unreachable, 10));
        std.debug.assert(tokens.peek() == null);
    }
    std.mem.sortUnstable(u32, list1.items, {}, std.sort.asc(u32));
    std.mem.sortUnstable(u32, list2.items, {}, std.sort.asc(u32));

    var difference: u32 = 0;
    for (list1.items, list2.items) |a, b| {
        difference += @truncate(@abs(@as(i33, a) - @as(i33, b)));
    }
    try std.fmt.format(stdout, "Part 1 answer (difference): {}\n", .{difference});

    var list2_occurrences = std.AutoHashMap(u32, u8).init(allocator);
    for (list2.items) |item| {
        const result = try list2_occurrences.getOrPut(item);
        if (result.found_existing) {
            result.value_ptr.* += 1;
        } else {
            result.value_ptr.* = 1;
        }
    }

    var similarity: u32 = 0;
    for (list1.items) |item| {
        if (list2_occurrences.get(item)) |count| {
            similarity += item * count;
        }
    }
    try std.fmt.format(stdout, "Part 2 answer (similarity): {}\n", .{similarity});
}
