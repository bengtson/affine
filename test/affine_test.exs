defmodule AffineTest do
  use ExUnit.Case
  doctest Affine

  test "3d translate, scale" do
      v = Affine.identity
      |> Affine.translate(1, 2, 3)
      |> Affine.scale(2, 2, 2)
      |> Affine.rotate_z(90.0, :degrees)
      |> Affine.transform(4, 5, 6)
      assert v == [ -9.0, 10.0, 15.0]
  end

end
