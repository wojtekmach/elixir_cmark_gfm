defmodule CmarkGFM do
  @on_load :__load_nif__

  @doc false
  def __load_nif__ do
    :erlang.load_nif(~c"_build/zig-out/libcmark_gfm_nif", 0)
  end

  @doc ~S"""
  Converts markdown to HTML.

  ## Examples

      iex> CmarkGFM.to_html("Hello, *World*!")
      "<p>Hello, <em>World</em>!</p>\n"
  """
  def to_html(_) do
    :erlang.nif_error("NIF library not loaded")
  end
end
