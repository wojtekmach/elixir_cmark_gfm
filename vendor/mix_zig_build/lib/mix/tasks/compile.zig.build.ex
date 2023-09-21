defmodule Mix.Tasks.Compile.Zig.Build do
  use Mix.Task

  @impl true
  def run(_args) do
    {_, 0} =
      System.cmd("zig", ["build"],
        env: %{
          "ZIG_LOCAL_CACHE_DIR" => "_build/zig-cache"
        }
      )

    for path <- Path.wildcard("_build/zig-out/lib*nif.dylib") do
      File.rename!(path, String.replace_trailing(path, ".dylib", ".so"))
    end

    :ok
  end
end
