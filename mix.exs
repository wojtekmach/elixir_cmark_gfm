defmodule CmarkGFM.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_cmark_gfm,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: ["zig.build"] ++ Mix.compilers()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:mix_zig_build, path: "vendor/mix_zig_build"}
    ]
  end
end
