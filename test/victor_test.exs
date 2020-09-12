defmodule VictorTest do
  use ExUnit.Case
  doctest Victor

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
      |> Victor.circle(%{x: 50, y: 50, r: 40})
      |> Victor.get_svg()

    expected =
      [
        ~s(<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">),
        ~s(\t<circle cx="50" cy="50" r="40" />),
        '</svg>'
      ]
      |> Enum.join("\n")

    assert result == expected
  end

  test "draws a rectangle" do
    result =
      Victor.new()
      |> Victor.rect(%{x: 10, y: 10, width: 80, height: 20})
      |> Victor.get_svg()

    expected =
      [
        ~s(<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">),
        ~s(\t<rect height="20" width="80" x="10" y="10" />),
        '</svg>'
      ]
      |> Enum.join("\n")

    assert result == expected
  end

  test "draws a styled rectangle" do
    result =
      Victor.new()
      |> Victor.rect(
        %{x: 10, y: 10, width: 80, height: 20},
        %{fill: "blue", stroke: "red"}
      )
      |> Victor.get_svg()

    expected =
      [
        ~s(<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">),
        ~s(\t<rect height="20" style="fill:blue;stroke:red" width="80" x="10" y="10" />),
        '</svg>'
      ]
      |> Enum.join("\n")

    assert result == expected
  end
end
