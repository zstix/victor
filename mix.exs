defmodule Victor.MixProject do
  use Mix.Project

  def project do
    [
      app: :victor,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end

  defp description() do
    """
    A simple solution for creating SVGs in Elixir.
    """
  end
end
