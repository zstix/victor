defmodule VictorTest do
  use ExUnit.Case
  doctest Victor

  @svg_open_tag ~s(<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">)

  test "makes a new Victor structure with default" do
    expected = %Victor{width: 100, height: 100, items: []}
    assert Victor.new() == expected
  end

  test "draws nothing when nothing is provided" do
    result =
      Victor.new()
      |> Victor.get_svg()

    expected = ~s(<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" />)

    assert result == expected
  end

  test "draws a circle" do
    result =
      Victor.new()
      |> Victor.add(:circle, %{cx: 50, cy: 50, r: 40})
      |> Victor.get_svg()

    expected =
      [
        @svg_open_tag,
        ~s(\t<circle cx="50" cy="50" r="40" />),
        '</svg>'
      ]
      |> Enum.join("\n")

    assert result == expected
  end

  test "draws a rectangle" do
    result =
      Victor.new()
      |> Victor.add(:rect, %{x: 10, y: 10, width: 80, height: 20})
      |> Victor.get_svg()

    expected =
      [
        @svg_open_tag,
        ~s(\t<rect height="20" width="80" x="10" y="10" />),
        '</svg>'
      ]
      |> Enum.join("\n")

    assert result == expected
  end

  test "draws a styled rectangle" do
    result =
      Victor.new()
      |> Victor.add(
        :rect,
        %{x: 10, y: 10, width: 80, height: 20},
        %{fill: "blue", stroke: "red"}
      )
      |> Victor.get_svg()

    expected =
      [
        @svg_open_tag,
        ~s(\t<rect height="20" style="fill:blue;stroke:red" width="80" x="10" y="10" />),
        '</svg>'
      ]
      |> Enum.join("\n")

    assert result == expected
  end

  test "draws a line" do
    result =
      Victor.new()
      |> Victor.add(:line, %{x1: 10, y1: 10, x2: 40, y2: 40})
      |> Victor.get_svg()

    expected =
      [
        @svg_open_tag,
        ~s(\t<line x1="10" x2="40" y1="10" y2="40" />),
        '</svg>'
      ]
      |> Enum.join("\n")

    assert result == expected
  end

  test "renders text" do
    result =
      Victor.new()
      |> Victor.add(:text, %{x: 10, y: 10, content: "What's your vector"})
      |> Victor.get_svg()

    expected =
      [
        @svg_open_tag,
        ~s(\t<text x="10" y="10">What's your vector</text>),
        '</svg>'
      ]
      |> Enum.join("\n")

    assert result == expected
  end

  test "indents the right number of times" do
    result =
      Victor.new()
      |> Victor.add(:circle, %{cx: 50, cy: 50, r: 40})
      |> Victor.add(:circle, %{cx: 80, cy: 80, r: 40})
      |> Victor.get_svg()

    expected =
      [
        @svg_open_tag,
        ~s(\t<circle cx="80" cy="80" r="40" />),
        ~s(\t<circle cx="50" cy="50" r="40" />),
        '</svg>'
      ]
      |> Enum.join("\n")

    assert result == expected
  end
end
