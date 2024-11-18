const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const String = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day03.txt");

const verbose: bool = true;

fn verbosePrint(comptime fmt: []const u8, args: anytype) void {
    if (verbose) {
        print(fmt, args);
    }
}

fn isDigit(c: u8) bool {
    return '0' <= c and c <= '9';
}

fn getValidNumbers(anyData: String) !List(u32) {
    var lines = splitSca(u8, anyData, '\n');
    // parse the grid once to get the dimensions
    var gridList = List([]const u8).init(gpa);
    defer gridList.deinit();
    var gridWidth: usize = 0;
    var gridHeight: usize = 0;
    while (lines.next()) |line| {
        try gridList.append(line);
        if (gridWidth == 0) {
            gridWidth = line.len;
        } else {
            assert(gridWidth == line.len);
        }
        gridHeight += 1;
    }
    // verbosePrint("width: {}, height: {}", .{ gridWidth, gridHeight });
    const grid = try gridList.toOwnedSlice();
    // now parse the grid to find numbers on each line
    var valid_numbers = List(u32).init(gpa);
    for (0..gridHeight) |y| {
        // var numberDigit: bool = false;
        var current_number: ?u32 = null;
        var valid_number: bool = false;
        for (0..gridWidth) |x| {
            const c = grid[y][x];
            if (c == '.') {
                if (current_number != null) {
                    // we are ending a number, so we need to check if it is a valid number
                    if (valid_number) {
                        try valid_numbers.append(current_number orelse unreachable);
                    }
                    // we start from scratch
                    // numberDigit = false;
                    current_number = null;
                    valid_number = false;
                } else {
                    // we are in a symbol, so do nothing
                }
            } else if (isDigit(c)) {
                // we are in a digit
                if (current_number != null) {
                    // we are continuing a number
                    current_number = (current_number orelse unreachable) * 10 + (c - '0');
                    // check only the top right, bottom right and right neighbors
                    const neighbors = [_]?u8{
                        if (y > 0 and x + 1 < gridWidth) grid[y - 1][x + 1] else null,
                        if (x + 1 < gridWidth) grid[y][x + 1] else null,
                        if (y + 1 < gridHeight and x + 1 < gridWidth) grid[y + 1][x + 1] else null,
                    };
                    for (neighbors) |neighbor| {
                        if (neighbor != null) {
                            if (isDigit(neighbor orelse unreachable) or neighbor == '.') {
                                // nothing
                            } else {
                                // this is a symbol, so this is a valid number
                                valid_number = true;
                                break;
                            }
                        }
                    }
                } else {
                    // we are starting a number
                    // numberDigit = true;
                    current_number = c - '0';
                    // check all neighbors (that exist)
                    const neighbors = [_]?u8{
                        if (y > 0 and x > 0) grid[y - 1][x - 1] else null,
                        if (y > 0) grid[y - 1][x] else null,
                        if (y > 0 and x + 1 < gridWidth) grid[y - 1][x + 1] else null,
                        if (x > 0) grid[y][x - 1] else null,
                        if (x + 1 < gridWidth) grid[y][x + 1] else null,
                        if (y + 1 < gridHeight and x > 0) grid[y + 1][x - 1] else null,
                        if (y + 1 < gridHeight) grid[y + 1][x] else null,
                        if (y + 1 < gridHeight and x + 1 < gridWidth) grid[y + 1][x + 1] else null,
                    };
                    for (neighbors) |neighbor| {
                        if (neighbor != null) {
                            if (isDigit(neighbor orelse unreachable) or neighbor == '.') {
                                // nothing
                            } else {
                                // this is a symbol, so this is a valid number
                                valid_number = true;
                                break;
                            }
                        }
                    }
                }
            } else {
                // symbol, do nothing
            }
        }
    }
    return valid_numbers;
}

pub fn main() !void {
    const valid_numbers = getValidNumbers(data);
    var sum: u32 = 0;
    print("valid numbers:\n", .{});
    for (valid_numbers.items) |number| {
        print("{}\n", .{number});
        sum += number;
    }
    // print the sum of all valid numbers
    print("sum: {}\n", .{sum});

    const data3 = "...766.......821.547.....577......................................387.....................56..........446.793..........292..................\n...........................%...../.....981..........627..../..........-.....623......610..-..............*..................16......891.....\n...$...........716..&336.......470.325.................*.84........$..34....*.....+.....#.....*76....#.........303.433........-........&....\n.117../359.#...............595............129..963#..722..........128........192.313........31........887...............234.......-.........\n............298.....922...*.......482.......*..................*......./.........................395................264..../.......166......";
    const expected = [_]u32{ 577, 56, 446, 793, 627, 623, 610, 16, 891, 336, 470, 84, 34, 76, 117, 359, 595, 129, 963, 722, 128, 192, 313, 31, 887, 234, 298, 166 };
    const expectedSlice: []const u32 = expected[0..];
    const actual = try getValidNumbers(data3);
    try std.testing.expect(std.mem.eql(u32, expectedSlice, actual.items));
}

test "part 1: small payload" {
    const data2 = "467..114..\n...*......\n..35..633.\n......#...\n617*......\n.....+.58.\n..592.....\n......755.\n...$.*....\n.664.598..";
    var expected = [_]u32{ 467, 35, 633, 617, 592, 755, 664, 598 };
    const expectedSlice: []const u32 = expected[0..];
    const actual = try getValidNumbers(data2);
    const works = std.mem.eql(u32, expectedSlice, actual.items);
    try std.testing.expect(works);
}

test "part 1: medium payload" {
    const data3 = "...766.......821.547.....577......................................387.....................56..........446.793..........292..................\n...........................%...../.....981..........627..../..........-.....623......610..-..............*..................16......891.....\n...$...........716..&336.......470.325.................*.84........$..34....*.....+.....#.....*76....#.........303.433........-........&....\n.117../359.#...............595............129..963#..722..........128........192.313........31........887...............234.......-.........\n............298.....922...*.......482.......*..................*......./.........................395................264..../.......166......";
    const expected = [_]u32{ 577, 56, 446, 793, 627, 623, 610, 16, 891, 336, 470, 84, 34, 76, 117, 359, 595, 129, 963, 722, 128, 192, 313, 31, 887, 234, 298, 166 };
    const expectedSlice: []const u32 = expected[0..];
    const actual = try getValidNumbers(data3);
    try std.testing.expect(std.mem.eql(u32, expectedSlice, actual.items));
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
