defmodule AffineTest do
  use ExUnit.Case
  doctest Affine

  test "3d translate, scale, rotate" do
      [ x, y, z ] =
        Affine.identity
        |> Affine.translate([1, 2, 3])
        |> Affine.scale([2, 2, 2])
        |> Affine.rotate_z(90.0, :degrees)
        |> Affine.transform([4, 5, 6])
      assert_in_delta(x, -9.0, 0.00001)
      assert_in_delta(y, 10.0, 0.00001)
      assert_in_delta(z, 15.0, 0.00001)
  end

  test "2d rotate" do
    [ x, y, 0.0 ] =
      Affine.identity
      |> Affine.rotate_z(45.0, :degrees)
      |> Affine.transform([1.0,0.0, 0.0])
    sqrt2 = :math.sqrt(2.0) / 2.0
    assert_in_delta(x, sqrt2, 0.00001)
    assert_in_delta(y, sqrt2, 0.00001)
  end

  test "1d linear map" do
    [ x, 0.0, 0.0 ] =
      Affine.identity
      |> Affine.translate([1.0, 0, 0])
      |> Affine.scale([2.0, 0, 0])
      |> Affine.transform([5.0,0,0])
    assert_in_delta(x, 11.0, 0.00001)
  end

  test "generator" do
    t = Affine.Generator.build(3)
    |> Affine.Generator.append(Affine.translate([1.0,0,0]))
    |> Affine.Generator.append(Affine.scale([2.0,2.0,2.0]))
    |> Affine.Generator.append(Affine.rotate_z(45.0, :degrees))
    |> Affine.Generator.generate
    IO.inspect t
  end

end
