# Victor

[![Hex.pm](https://img.shields.io/hexpm/v/victor.svg)](https://hex.pm/packages/victor)

A simple solution for creating SVGs in Elixir.

_What's your vector victor?_

Full documentation can be found at [https://hexdocs.pm/victor](https://hexdocs.pm/victor).

## Installation

The package can be installed by adding `victor` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [{:victor, "~> 0.1.1"}]
end
```

## Basic Usage

```elixir
def make_art do
  Victor.new()
  |> Victor.add(:rect, %{x: 20, y: 20, width: 60, height: 10})
  |> Victor.add(:circle, %{cx: 10, cy: 50, r: 10}, %{fill: "blue"})
  |> Victor.add(:text, %{x: 40, y: 50, content: "Tada!"})
  |> Victor.get_svg()
  |> Victor.write_file("/tmp/art.svg")
end
```

![Example](https://github.com/zstix/victor/blob/master/examples/art.svg?raw=true)
