defmodule Victor do
  @moduledoc """
  Documentation for `Victor`.
  """

  # TODO: document

  defstruct width: 100, height: 100, items: [], style: %{}

  def new(), do: %Victor{}

  def build(%{width: width, height: height, items: items, style: style}) do
    {
      :svg,
      %{
        viewBox: "0 0 #{width} #{height}",
        xmlns: "http://www.w3.org/2000/svg"
      },
      items
    }
    |> tag_to_string(style)
  end

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

  defp style_to_string(style, _) when style == %{}, do: ""
  defp style_to_string(_, tag) when tag == :svg, do: ""

  defp style_to_string(style, _) do
    [
      ~s( style="),
      style
      |> Enum.map(fn {key, value} -> "#{key}:#{value}" end)
      |> Enum.join(";"),
      "\""
    ]
    |> Enum.join()
  end

  defp tag_to_string({tag, props, []}, style) do
    [
      "<",
      Atom.to_string(tag),
      " ",
      props_to_string(props),
      style_to_string(style, tag),
      " />"
    ]
    |> Enum.join()
  end

  defp tag_to_string({tag, props, children}, style) do
    [
      "<",
      Atom.to_string(tag),
      " ",
      props_to_string(props),
      style_to_string(style, tag),
      ">\n",
      get_indent(children),
      children
      |> Enum.map(&tag_to_string(&1, style))
      |> Enum.join("\n" <> get_indent(children)),
      "\n</",
      Atom.to_string(tag),
      ">"
    ]
    |> Enum.join()
  end

  # TODO: move to module?

  def style(victor, style) do
    %Victor{victor | style: style}
  end

  def circle(%{items: items} = victor, %{x: x, y: y, r: r}) do
    circle = {:circle, %{cx: x, cy: y, r: r}, []}
    new_items = [circle | items]

    %Victor{victor | items: new_items}
  end

  def rect(%{items: items} = victor, props) do
    rect = {:rect, props, []}
    new_items = [rect | items]

    %Victor{victor | items: new_items}
  end
end
