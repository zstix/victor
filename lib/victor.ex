defmodule Victor do
  @moduledoc """
  Documentation for `Victor`.
  """

  # TODO: document

  defstruct width: 100, height: 100, items: []

  def new(), do: %Victor{}

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

  defp tag_to_string({tag, props, []}) do
    ~s(<#{Atom.to_string(tag)} #{props_to_string(props)} />)
  end

  defp tag_to_string({tag, props, children}) do
    [
      ~s(<#{Atom.to_string(tag)} #{props_to_string(props)}>\n),
      get_indent(children),
      children
      |> Enum.map(&tag_to_string/1)
      |> Enum.join("\n" <> get_indent(children)),
      ~s(\n</#{Atom.to_string(tag)}>)
    ]
    |> Enum.join()
  end

  # TODO: move to module?
  def circle(%{items: items} = victor, %{x: x, y: y, r: r}) do
    circle = {:circle, %{cx: x, cy: y, r: r}, []}
    new_items = [circle | items]

    %Victor{victor | items: new_items}
  end
end
