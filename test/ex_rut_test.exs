defmodule ExRutTest do
  use ExUnit.Case
  doctest ExRut

  test "greets the world" do
    assert ExRut.hello() == :world
  end
end
