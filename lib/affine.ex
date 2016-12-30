defmodule Affine do
  @moduledoc """
  This module performs Affine Transforms for 1, 2 and 3 dimensions. The
  implementation is simple in this initial version allowing for translation,
  scaling and rotation.

  An example of usage is:

      v = Affine.identity
      |> Affine.translate([1, 2, 3])
      |> Affine.scale([2, 2, 2])
      |> Affine.rotate_z(90.0, :degrees)
      |> Affine.transform([4, 5, 6])

  As the transform is built before being applied, the order of the operations
  is reversed as is typical for an Affine Transform. In this case, the point
  (4, 5, 6) is first rotated about the z axis, then scaled by 2 in each
  direction followed by a translation of (1, 2, 3). The result will be the
  point (-9.0, 10.0, 15.0).
  """

  @type matrix :: [[number]]
  @type point :: [number]

  @doc """

  """
  def new do
    []
  end

  @doc """
  Returns the identity matrix which can be used as the starting point in
  building a transform.
  """
  @spec identity() :: matrix
  def identity do
    [
      [ 1.0, 0.0, 0.0, 0.0 ],
      [ 0.0, 1.0, 0.0, 0.0 ],
      [ 0.0, 0.0, 1.0, 0.0 ],
      [ 0.0, 0.0, 0.0, 1.0 ]
    ]
  end

  @doc """
  Appends a specified translation to the supplied transform. One, two or
  three variables may be provided. Variables not supplied default to 0.
  """
  @spec translate(matrix, point) :: matrix
  def translate [x,y,z] do
    translate Matrix.ident(4), [x,y,z]
  end
  def translate t, [x,y,z] do
    op =
    [
      [ 1.0, 0.0, 0.0,   x ],
      [ 0.0, 1.0, 0.0,   y ],
      [ 0.0, 0.0, 1.0,   z ],
      [ 0.0, 0.0, 0.0, 1.0 ]
    ]
#    ExMatrix.pmultiply t, op
    Matrix.mult t, op
  end

  @doc """
  Appends a specified scale to the transform. A scaling factor can be provided
  for the x, y and z directions. Defaults if not provided are a scaling factor
  of 1.0.
  """
  @spec scale(matrix, point) :: matrix
  def scale [x,y,z] do
    scale Matrix.ident(4), [x,y,z]
  end
  def scale t, [x, y, z] do
    op =
    [
      [   x, 0.0, 0.0, 0.0 ],
      [ 0.0,   y, 0.0, 0.0 ],
      [ 0.0, 0.0,   z, 0.0 ],
      [ 0.0, 0.0, 0.0, 1.0 ]
    ]
    Matrix.mult t, op
#    ExMatrix.pmultiply t, op
  end

  @doc """
  Appends a rotation around the x axis in the counter clockwise direction for
  the specified angle. The angle defaults to :degrees but can optionally be
  specified as :radians.
  """
  @spec rotate_x(matrix,number,:degrees | :radians) :: matrix
  def rotate_x [x,y,z] do
    rotate_x Matrix.ident(4), [x,y,z]
  end
  def rotate_x t, angle, units \\ :degrees do
    { sin, cos } = sin_cos angle, units
    op =
    [
      [ 1.0,  0.0,  0.0, 0.0 ],
      [ 0.0,  cos, -sin, 0.0 ],
      [ 0.0,  sin,  cos, 0.0 ],
      [ 0.0,  0.0,  0.0, 1.0 ]
    ]
    Matrix.mult t, op
  end

  @doc """
  Appends a rotation around the y axis in the counter clockwise direction for
  the specified angle. The angle defaults to :degrees but can optionally be
  specified as :radians.
  """
  @spec rotate_y(matrix,number,:degrees | :radians) :: matrix
  def rotate_y [x,y,z] do
    rotate_y Matrix.ident(4), [x,y,z]
  end
  def rotate_y t, angle, units \\ :degrees do
    { sin, cos } = sin_cos angle, units
    op =
    [
      [  cos,  0.0,  sin, 0.0 ],
      [  0.0,  1.0,  0.0, 0.0 ],
      [ -sin,  0.0,  cos, 0.0 ],
      [  0.0,  0.0,  0.0, 1.0 ]
    ]
    Matrix.mult t, op
  end

  @doc """
  Appends a rotation around the z axis in the counter clockwise direction for
  the specified angle. The angle defaults to :degrees but can optionally be
  specified as :radians.
  """
  @spec rotate_z(matrix,number,:degrees | :radians) :: matrix
  def rotate_z angle, units do
    rotate_z Matrix.ident(4), angle, units
  end
  def rotate_z t, angle, units do
    { sin, cos } = sin_cos angle, units
    op =
    [
      [ cos, -sin, 0.0, 0.0 ],
      [ sin,  cos, 0.0, 0.0 ],
      [ 0.0,  0.0, 1.0, 0.0 ],
      [ 0.0,  0.0, 0.0, 1.0 ]
    ]
    Matrix.mult t, op
  end

  @doc """
  Transforms the provided x,y,z point with the specified transform. Returns the
  transformed point.
  """
  @spec transform(matrix,point) :: point
  def transform t, [x, y, z] do

    r = Matrix.transpose [[x, y, z, 1]]
    x = Matrix.mult(t,r)
    [[x],[y],[z],[_]] = x
    [x,y,z]
  end

  # Converts the angle based on units specified by user and returns
  # the sin and cos for the angle. This is a helper function for the
  # rotate transforms.
  defp sin_cos angle, units do
    a = case units do
      :degrees -> angle / 180.0 * :math.pi()
      _ -> angle
    end
    { :math.sin(a), :math.cos(a) }
  end

end
