defmodule Victor do
  @moduledoc """
  Documentation for `Victor`.
  """

  # TODO: document

  defstruct width: 100, height: 100, items: []

  def new(), do: %Victor{}

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
