defmodule CwgenTest do
  use ExUnit.Case
  doctest Cwgen

  test "greets the world" do
    assert Cwgen.hello() == :world
  end
end
