const std = @import("std");

pub fn PPMWriter(comptime WriterType: type) type {
    return struct {
        writer: WriterType,
        max_col: usize = 255,
        w: usize = 0,
        h: usize = 0,

        const Self = @This();

        pub fn printPixel(self: *Self, r: usize, g: usize, b: usize) !void {
            try self.writer.print("{} {} {}\n", .{ r, g, b });
        }

        pub fn printPixelNorm(self: *Self, r: f32, g: f32, b: f32) !void {
            const rs = @floatToInt(usize, r * @intToFloat(f32, self.max_col));
            const gs = @floatToInt(usize, g * @intToFloat(f32, self.max_col));
            const bs = @floatToInt(usize, b * @intToFloat(f32, self.max_col));
            try self.printPixel(self, rs, gs, bs);
        }

        pub fn printMeta(self: *Self, w: usize, h: usize, max_col: usize) !void {
            self.max_col = max_col;
            self.w = w;
            self.h = h;
            try self.writer.print("P3\n{} {}\n{}\n", .{ w, h, max_col });
        }
    };
}

pub fn ppmWriter() PPMWriter(@TypeOf(std.io.getStdOut().writer())) {
    const stdout = std.io.getStdOut().writer();
    return .{ .writer = stdout };
}
