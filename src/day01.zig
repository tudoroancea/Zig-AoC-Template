const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

const str = []const u8;
const spelledOutNumbers = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
const lengthsOfSpelledOutNumbers = [_]u8{ 3, 3, 5, 4, 4, 3, 5, 5, 4 };

pub fn main() !void {
    // PART 1 ================================================================
    // split the data line by line
    var lines = splitSca(u8, data, '\n');
    // extract the digits on each line into a list of lists
    var twoDigitNumbers = List(u8).init(gpa);
    defer twoDigitNumbers.deinit();
    var lineDigits = List(u8).init(gpa);
    defer lineDigits.deinit();
    // while (lines.next()) |line| {
    //     try lineDigits.resize(0);
    //     for (line) |c| {
    //         if (c >= '0' and c <= '9') {
    //             try lineDigits.append(c - '0');
    //         }
    //     }
    //     assert(lineDigits.items.len > 0);
    //     // check that the line has at least two digits
    //     if (lineDigits.items.len < 1) {
    //         continue;
    //     }
    //     // find the first and last digit, and put them together to make a two-digit number
    //     const first = lineDigits.items[0];
    //     const last = lineDigits.items[lineDigits.items.len - 1];
    //     const twoDigitNumber = first * 10 + last;
    //     try twoDigitNumbers.append(twoDigitNumber);
    // }
    // // print the sum of all the two-digit numbers
    var sum: u32 = 0;
    // for (twoDigitNumbers.items) |twoDigitNumber| {
    //     sum += twoDigitNumber;
    // }
    // print("Part 1: {}\n", .{sum});

    // PART 2 ================================================================
    // lines = splitSca(u8, data, '\n');
    try twoDigitNumbers.resize(0);
    var line_num: u32 = 1;
    while (lines.next()) |line| {
        // if (line_num > 10) {
        //     break;
        // }
        print(
            "==============================================================================================\nline {}: {s}\n",
            .{ line_num, line },
        );
        try lineDigits.resize(0);
        // find either the digit or the spelled-out numbers
        var i: usize = 0;
        while (i < line.len) {
            const c = line[i];
            if (c >= '0' and c <= '9') {
                try lineDigits.append(c - '0');
                i += 1;
                print("lineDigits.last: {}\n", .{lineDigits.items[lineDigits.items.len - 1]});
            } else {
                // find the spelled-out number
                var found: bool = false;
                for (spelledOutNumbers, 0..) |num, j| {
                    const len = lengthsOfSpelledOutNumbers[j];
                    if (i + len > line.len) {
                        continue;
                    }
                    const eq = std.mem.eql(u8, num, line[i .. i + len]);
                    print("i:{}, j:{}, {s} == {s} is {}\n", .{ i, j, num, line[i .. i + len], eq });
                    if (eq) {
                        try lineDigits.append(@as(u8, @intCast(j)) + 1);
                        print("adding {} to lineDigits\n", .{lineDigits.items[lineDigits.items.len - 1]});
                        i += len;
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    i += 1;
                }
            }
        }

        // check that the line has at least two digits
        if (lineDigits.items.len < 1) {
            continue;
        }
        // find the first and last digit, and put them together to make a two-digit number
        const first = lineDigits.items[0];
        const last = lineDigits.items[lineDigits.items.len - 1];
        print("lineDigits: {}, first: {}, last: {}\n", .{ lineDigits, first, last });
        const twoDigitNumber = first * 10 + last;
        try twoDigitNumbers.append(twoDigitNumber);
        print("twoDigitNumber: {}\n", .{twoDigitNumber});
        line_num += 1;
    }
    sum = 0;
    for (twoDigitNumbers.items) |twoDigitNumber| {
        sum += twoDigitNumber;
    }
    print("Part 2: {}\n", .{sum});
}

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
