const std = @import("std");

const c = @cImport({
    @cInclude("string.h");
});

const cmark = @cImport({
    @cInclude("cmark-gfm.h");
});

const nif = @cImport({
    @cInclude("erl_nif.h");
});

export fn to_html_nif(env: ?*nif.ErlNifEnv, argc: c_int, argv: [*c]const nif.ERL_NIF_TERM) nif.ERL_NIF_TERM {
    _ = argc;
    var input_binary: nif.ErlNifBinary = undefined;
    var output_binary: nif.ErlNifBinary = undefined;

    if (nif.enif_inspect_binary(env, argv[0], &input_binary) == 0) {
        return nif.enif_make_badarg(env);
    }
    defer nif.enif_release_binary(&input_binary);

    const options: u8 = 0;
    var doc = cmark.cmark_parse_document(input_binary.data, input_binary.size, options);
    defer cmark.cmark_node_free(doc);
    var string = cmark.cmark_render_html(doc, options, 0);

    var output_len = c.strlen(string);
    _ = nif.enif_alloc_binary(output_len, &output_binary);
    _ = c.memcpy(output_binary.data, string, output_len);
    return nif.enif_make_binary(env, &output_binary);
}

var nif_funcs = [_]nif.ErlNifFunc{
    nif.ErlNifFunc{
        .name = "to_html",
        .arity = 1,
        .fptr = to_html_nif,
        .flags = 0,
    },
};

const entry = nif.ErlNifEntry{
    .major = 2,
    .minor = 16,
    .name = "Elixir.CmarkGFM",
    .num_of_funcs = nif_funcs.len,
    .funcs = &(nif_funcs[0]),
    .load = null,
    .reload = null,
    .upgrade = null,
    .unload = null,
    .vm_variant = "beam.vanilla",
    .options = 1,
    .sizeof_ErlNifResourceTypeInit = @sizeOf(nif.ErlNifResourceTypeInit),
    .min_erts = "erts-13.1.2",
};

export fn nif_init() *const nif.ErlNifEntry {
    return &entry;
}
