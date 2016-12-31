defmodule AffineTest do
  use ExUnit.Case
  doctest Affine

  test "low level translate 3d" do
    t_translate = Affine.Transforms.translate 4.0, 5.0, 6.0
    point = Affine.t t_translate, [1.0, 2.0, 3.0]
    assert point == [5.0, 7.0, 9.0]
  end

  test "low level translate, scale, rotate 3d" do
    [ x, y, z ] =
    Matrix.ident(4)
    |> Affine.m(Affine.Transforms.translate(1,2,3))
    |> Affine.m(Affine.Transforms.scale(2,2,2))
    |> Affine.m(Affine.Transforms.rotate_z(:math.pi()/2.0))
    |> Affine.t([4,5,6])
    assert_in_delta(x, -9.0, 0.00001)
    assert_in_delta(y, 10.0, 0.00001)
    assert_in_delta(z, 15.0, 0.00001)
  end

  test "low level rotate 2d" do
    [ x, y ] =
      Matrix.ident(3)
      |> Affine.m(Affine.Transforms.rotate_xy(:math.pi()/4.0))
      |> Affine.t([1.0, 0.0])
      sqrt2 = :math.sqrt(2.0) / 2.0
      assert_in_delta(x, sqrt2, 0.00001)
      assert_in_delta(y, sqrt2, 0.00001)
  end

  test "low level 1d linear map" do
    [ x ] =
    Matrix.ident(2)
      |> Affine.m(Affine.Transforms.translate(1.0))
      |> Affine.m(Affine.Transforms.scale(2.0))
      |> Affine.t([5.0])
    assert_in_delta(x, 11.0, 0.00001)
  end

  test "high level translate 3d" do
    point =
      [type: :translate, dimensions: 3, x: 4.0, y: 5.0, z: 6.0]
      |> Affine.create
      |> Affine.t([1.0,2.0,3.0])
      assert point == [5.0, 7.0, 9.0]
  end

  test "high level rotate 2d" do
    [ x, y ] =
      [type: :rotate_xy, dimensions: 2, angle: 30.0, units: :degrees]
      |> Affine.create
      |> Affine.t([5.0,0.0])
      assert_in_delta(x, 4.3301, 0.001)
      assert_in_delta(y, 2.5000, 0.001)
  end

  test "high level translate, scale 3d " do
    point =
      [ [type: :translate, dimensions: 3, x: 3.0, y: 4.0, z: 5.0],
        [type: :scale, dimensions: 3, x: 2.0, y: 2.0, z: 2.0] ]
      |> Affine.create
      |> Affine.t([1.0,2.0,3.0])
    assert point == [8.0, 12.0, 16.0]
  end

  test "linear map" do
    linear_map =
    [type: :linear_map, x1_in: 0.0, x1_out: 143.0, x2_in: 21.0, x2_out: 200.0]
      |> Affine.create

    assert Affine.map(linear_map, 0.0) == 143.0
    assert Affine.map(linear_map, 21.0) == 200.0
  end

end
