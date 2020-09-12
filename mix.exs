defmodule Victor.MixProject do
  use Mix.Project

  def project do
    [
      app: :victor,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "Victor",
      description: description(),
      source_url: "https://github.com/zstix/victor"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Zack Stickles"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/zstix/victor"}
    ]
  end

  defp description() do
    """
    A simple solution for creating SVGs in Elixir.
    """
  end
end
