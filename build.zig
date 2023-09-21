const std = @import("std");

pub fn build(b: *std.Build) void {
    b.lib_dir = "_build/zig-out";
    b.h_dir = "_build/zig-out";

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const cmark_gfm_build = @import("vendor/zig-build-cmark-gfm/build.zig");
    const cmark_gfm_lib = cmark_gfm_build.install(b, target, optimize, "vendor/zig-build-cmark-gfm");

    const lib = b.addSharedLibrary(.{
        .name = "cmark_gfm_nif",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib.linker_allow_shlib_undefined = true;
    // TODO: get path from: elixir -e "..."
    lib.addIncludePath(.{
        .path = "/Users/wojtek/.local/share/rtx/installs/erlang/26.0.2/usr/include",
    });

    lib.addIncludePath(.{ .path = b.h_dir });
    lib.linkLibrary(cmark_gfm_lib);

    b.installArtifact(lib);
}
