defmodule Victor do
  @moduledoc """
  Documentation for `Victor`.
  """

  # TODO: document

  defstruct width: 100, height: 100, items: []

  def new(), do: %Victor{}

  def build(%{width: width, height: height, items: []}) do
    svg = {
      :svg,
      %{viewBox: "0 0 #{width} #{height}", xmlns: "http://www.w3.org/2000/svg"},
      nil
    }

    tag_to_string(svg)
  end

  def build(%{width: width, height: height, items: items}) do
    [
      ~s(<svg viewBox="0 0 #{width} #{height}" xmlns="http://www.w3.org/2000/svg">),
      Enum.map(items, &tag_to_string/1),
      "</svg>"
    ]
    |> Enum.join("\n")
  end

  def create_file(svg, filepath) do
    File.write(filepath, svg)
  end

  # TODO: make this work with children
  # TODO: use this to build rather than looping above
  defp tag_to_string({tag, props, nil}) do
    [
      "<#{Atom.to_string(tag)}",
      props
      |> Enum.map(fn {key, value} -> ~s(#{key}="#{value}") end),
      "/>"
    ]
    |> List.flatten()
    |> Enum.join(" ")
  end

  # TODO: move to module?
  def circle(%{items: items} = victor, %{x: x, y: y, r: r}) do
    circle = {:circle, %{cx: x, cy: y, r: r}, nil}
    new_items = [circle | items]

    %Victor{victor | items: new_items}
  end
end
