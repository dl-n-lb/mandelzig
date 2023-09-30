const std = @import("std");
const math = std.math;
const zmath = @import("zmath");
const Complex = std.math.complex.Complex(f32);
const ppmwriter = @import("ppmwriter");

const width = 1920;
const height = 1080;

fn mandelbrot(c: Complex) bool {
    var z = c;
    comptime var it: usize = 0;
    inline while (it < 100) : (it += 1) {
        z = z.mul(z).add(c);
        if (z.magnitude() > 2)
            return false;
    }
    return true;
}

pub fn main() !void {
    var ppmw = ppmwriter.ppmWriter();

    try ppmw.printMeta(width, height, 255);

    const ar = @intToFloat(f32, width) / @intToFloat(f32, height);

    var i: usize = 0;
    while (i < width * height) : (i += 1) {
        const x = @mod(i, width);
        const y = @divFloor(i, width);
        const re = @intToFloat(f32, x) / @intToFloat(f32, width);
        const im = @intToFloat(f32, y) / @intToFloat(f32, height);
        const c = Complex.init(ar * (3 * re - 2), 3 * im - 1.5);
        const in_set = mandelbrot(c);
        if (!in_set) try ppmw.printPixel(0, 0, 0) else try ppmw.printPixel(255, 255, 255);
    }
}
