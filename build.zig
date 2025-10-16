const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "brainfuck",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .optimize = optimize,
            .target = target,
        }),
    });

    exe.linkLibC();
    b.installArtifact(exe);

    const run_step = b.step("run", "Run the interpreter");
    const run = b.addRunArtifact(exe);

    if (b.args) |args| run.addArgs(args);
    run.step.dependOn(b.getInstallStep());
    run_step.dependOn(&run.step);
}
