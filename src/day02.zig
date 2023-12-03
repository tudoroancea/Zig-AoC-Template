const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const String = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

const verbose: bool = false;

fn verbosePrint(comptime fmt: []const u8, args: anytype) void {
    if (verbose) {
        print(fmt, args);
    }
}

const maxRed = 12;
const maxGreen = 13;
const maxBlue = 14;

fn check(gameRounds: String) !bool {
    // split the game into rounds by the semicolon
    var rounds = splitSca(u8, gameRounds, ';');
    // for each round, split into the colors by the comma
    while (rounds.next()) |round| {
        var colors = splitSca(u8, round, ',');
        // for each color, check if it's valid
        while (colors.next()) |color| {
            // find the number of each color, and whether it's red, green, or blue
            const sep = lastIndexOf(u8, color, ' ') orelse unreachable;
            const num = try parseInt(u8, color[1..sep], 10);
            switch (color[sep + 1]) {
                'r' => if (num > maxRed) return false,
                'g' => if (num > maxGreen) return false,
                'b' => if (num > maxBlue) return false,
                else => unreachable,
            }
        }
    }
    return true;
}

pub fn main() !void {
    var games = splitSca(u8, data, '\n');
    var validGames: u32 = 0;
    while (games.next()) |game| {
        const colonIndex = indexOf(u8, game, ':') orelse unreachable;
        const gameRounds = game[(colonIndex + 1)..];
        if (try check(gameRounds)) {
            // cast the slice game[5..colonIndex] to a String
            const gameIndex = try parseInt(u8, game[5..colonIndex], 10);
            validGames += gameIndex;
        }
    }
    print("Part 1: There are {} valid games\n", .{validGames});
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
