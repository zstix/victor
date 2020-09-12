# Victor

A simple solution for creating SVGs in Elixir.

_What's your vector victor?_

## Installation

The package can be installed by adding `victor` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [{:victor, "~> 0.1.0"}]
end
```

## Basic Usage

```elixir
def make_art do
  Victor.new()
  |> Victor.add(:rect, %{x: 20, y: 20, width: 60, height: 10})
  |> Victor.add(:circle, %{cx: 10, cy: 50, r: 10}, ${fill: "blue"})
  |> Victor.add(:text, %{x: 40, y: 40, content: "Tada!"})
  |> Victor.get_svg()
  |> Victor.write_file("/tmp/art.svg")
end
```

Full documentation can be found at [https://hexdocs.pm/victor](https://hexdocs.pm/victor).
