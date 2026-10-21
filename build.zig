const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const build_zig_zon = b.createModule(.{
        .root_source_file = b.path("build.zig.zon"),
        .target = target,
        .optimize = optimize,
    });

    const mod = b.addModule("drivercom", .{
        .root_source_file = b.path("src/drivercom.zig"),
        .target = target,
        .optimize = optimize,
    });
    mod.addImport("build.zig.zon", build_zig_zon);

    const mod_unit_tests = b.addTest(.{ .root_module = mod });
    const run_mod_unit_tests = b.addRunArtifact(mod_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_mod_unit_tests.step);
}
