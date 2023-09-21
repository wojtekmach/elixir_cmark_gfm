const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    install(b, target, optimize, ".");
}

pub fn install(b: *std.Build, target: anytype, optimize: anytype, comptime root: []const u8) *std.Build.Step.Compile {
    const lib = b.addStaticLibrary(.{
        .name = "cmark-gfm",
        .target = target,
        .optimize = optimize,
    });

    lib.addIncludePath(.{ .path = root ++ "/upstream/src" });
    lib.addIncludePath(.{ .path = root ++ "/override/include" });

    var flags = std.ArrayList([]const u8).init(b.allocator);
    defer flags.deinit();

    const srcs = &.{
        root ++ "/upstream/src/cmark.c",
        root ++ "/upstream/src/node.c",
        root ++ "/upstream/src/iterator.c",
        root ++ "/upstream/src/blocks.c",
        root ++ "/upstream/src/inlines.c",
        root ++ "/upstream/src/scanners.c",
        root ++ "/upstream/src/utf8.c",
        root ++ "/upstream/src/buffer.c",
        root ++ "/upstream/src/references.c",
        root ++ "/upstream/src/footnotes.c",
        root ++ "/upstream/src/map.c",
        root ++ "/upstream/src/render.c",
        root ++ "/upstream/src/man.c",
        root ++ "/upstream/src/xml.c",
        root ++ "/upstream/src/html.c",
        root ++ "/upstream/src/commonmark.c",
        root ++ "/upstream/src/plaintext.c",
        root ++ "/upstream/src/latex.c",
        root ++ "/upstream/src/houdini_href_e.c",
        root ++ "/upstream/src/houdini_html_e.c",
        root ++ "/upstream/src/houdini_html_u.c",
        root ++ "/upstream/src/cmark_ctype.c",
        root ++ "/upstream/src/arena.c",
        root ++ "/upstream/src/linked_list.c",
        root ++ "/upstream/src/syntax_extension.c",
        root ++ "/upstream/src/registry.c",
        root ++ "/upstream/src/plugin.c",
    };

    lib.addCSourceFiles(srcs, flags.items);

    lib.installHeadersDirectoryOptions(.{
        .source_dir = .{ .path = root ++ "/upstream/src" },
        .install_dir = .header,
        .install_subdir = "",
        .exclude_extensions = &.{
            ".build",
            ".c",
            ".cc",
            ".hh",
            ".in",
            ".py",
            ".rs",
            ".rl",
            ".ttf",
            ".txt",
        },
    });

    lib.installHeadersDirectoryOptions(.{
        .source_dir = .{ .path = root ++ "/override/include" },
        .install_dir = .header,
        .install_subdir = "",
    });
    lib.linkLibC();

    b.installArtifact(lib);
    return lib;
}
