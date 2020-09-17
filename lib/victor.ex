defmodule Victor do
  @moduledoc """
  A simple solution for creating SVGs in Elixir.
  """

  defstruct width: 100, height: 100, items: []

  @doc """
  Creates a new Victor.

  ## Parameters

    * `size` - An optional map with `width` and `height` keys.

  ## Examples

      iex> Victor.new()
      %Victor{width: 100, height: 100, items: []}

      iex> Victor.new(%{width: 600, height: 400})
      %Victor{width: 600, height: 400, items: []}

  """
  def new(), do: %Victor{}

  def new(%{width: width, height: height}) do
    %Victor{width: width, height: height}
  end

  @doc """
  Adds a new SVG item to a Victor.

  ## Parameters

    * `victor` - A Victor struct to add the item to.
    * `tag` - The SVG tag type to be added (as an atom).
    * `props` - A map of properties for the SVG item (i.e. `width`).
    * `style` - An optional map of style properties for the SVG item.

  ## Examples

      iex> Victor.add(%Victor{}, :circle, %{cx: 10, cy: 10, r: 20})
      %Victor{
        height: 100,
        items: [{:circle, %{cx: 10, cy: 10, r: 20}, []}],
        width: 100
      }

      iex> Victor.add(%Victor{}, :rect, %{x: 10, y: 10, width: 100, height: 50}, %{fill: "red"})
      %Victor{
        height: 100,
        items: [
          {:rect, %{height: 50, style: "fill:red", width: 100, x: 10, y: 10}, []}
        ],
        width: 100
      }

  """
  def add(%{items: items} = victor, tag, props, style \\ %{}) do
    item =
      case tag do
        :text ->
          {
            tag,
            get_tag_props(Map.drop(props, [:content]), style),
            Map.get(props, :content)
          }

        _ ->
          {tag, get_tag_props(props, style), []}
      end

    %Victor{victor | items: [item | items]}
  end

  @doc ~S"""
  Gets the string representation of a SVG.

  ## Parameters

    * `victor` - A Victor struct to convert to a string.

  ## Examples

      iex> Victor.get_svg(%Victor{})
      "<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\" />"

      iex> Victor.add(%Victor{}, :circle, %{cx: 10, cy: 10, r: 20}) |> Victor.get_svg()
      "<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\">\n\t<circle cx=\"10\" cy=\"10\" r=\"20\" />\n</svg>"

  """
  def get_svg(%{width: width, height: height, items: items}) do
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

  @doc """
  Writes a SVG string to a given file.

  A simple wrapper around `File.write/2`.

  ## Parameters

    * `svg` - A string representation of a SVG.
    * `filepath` - The path to the file.

  """
  def write_file(svg, filepath) do
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

  defp tag_to_string({tag, props, children}) when is_list(children) do
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

  defp tag_to_string({tag, props, children}) when is_bitstring(children) do
    tag_name = Atom.to_string(tag)

    ["<", tag_name, " ", props_to_string(props), ">", children, "</", tag_name, ">"]
    |> Enum.join()
  end

  defp get_tag_props(props, style) when style == %{}, do: props

  defp get_tag_props(props, style) do
    style_val =
      style
      |> Enum.map(fn {key, value} -> "#{key}:#{value}" end)
      |> Enum.join(";")

    Map.merge(props, %{style: style_val})
  end
end
