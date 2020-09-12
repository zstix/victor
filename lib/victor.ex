defmodule Victor do
  @moduledoc """
  Documentation for `Victor`.
  """

  # TODO: document

  defstruct width: 100, height: 100, items: []

  # TODO: rename?
  def new(), do: %Victor{}

  # TODO: rename
  def build(%{width: width, height: height, items: items}) do
    {
      :svg,
      %{
        viewBox: "0 0 #{width} #{height}",
        xmlns: "http://www.w3.org/2000/svg"
      },
      items
    }
    |> tag_to_string()
  end

  # TODO: rename
  def create_file(svg, filepath) do
    File.write(filepath, svg)
  end

  defp get_indent(children) do
    children
    |> length()
    |> Range.new(0)
    |> Enum.map(fn _ -> "\t" end)
    |> tl()
    |> Enum.join()
  end

  defp props_to_string(props) do
    props
    |> Enum.map(fn {key, value} -> ~s(#{key}="#{value}") end)
    |> Enum.join(" ")
  end

  defp tag_to_string({tag, props, children}) do
    tag_name = Atom.to_string(tag)
    tag = ["<", tag_name, " ", props_to_string(props)]

    child_tags =
      children
      |> Enum.map(&tag_to_string/1)
      |> Enum.join("\n" <> get_indent(children))

    tail =
      case length(children) do
        0 ->
          [" />"]

        _ ->
          [
            ">\n",
            get_indent(children),
            child_tags,
            "\n</",
            tag_name,
            ">"
          ]
      end

    Enum.join(tag ++ tail)
  end

  defp get_tag_props(props, style) when style == %{}, do: props

  defp get_tag_props(props, style) do
    style_val =
      style
      |> Enum.map(fn {key, value} -> "#{key}:#{value}" end)
      |> Enum.join(";")

    Map.merge(props, %{style: style_val})
  end

  # TODO: move to module?

  def circle(%{items: items} = victor, %{x: x, y: y, r: r}, style \\ %{}) do
    circle = {:circle, get_tag_props(%{cx: x, cy: y, r: r}, style), []}
    new_items = [circle | items]

    %Victor{victor | items: new_items}
  end

  def rect(%{items: items} = victor, props, style \\ %{}) do
    rect = {:rect, get_tag_props(props, style), []}
    new_items = [rect | items]

    %Victor{victor | items: new_items}
  end
end
