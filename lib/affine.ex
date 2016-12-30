defmodule Affine do
  @moduledoc """
  This module performs Affine Transforms for 1, 2 and 3 dimensions. The
  implementation is simple in this initial version allowing for translation,
  scaling and rotation.

  An example of usage is:

    v = Affine.identity
    |> Affine.translate(1, 2, 3)
    |> Affine.scale(2, 2, 2)
    |> Affine.rotate_z(90.0, :degrees)
    |> Affine.transform(4, 5, 6)

  As the transform is built before being applied, the order of the operations
  is reversed as is typical for an Affine Transform. In this case, the point
  (4, 5, 6) is first rotated about the z axis, then scaled by 2 in each
  direction followed by a translation of (1, 2, 3). The result will be the
  point (-9.0, 10.0, 15.0).
  """

  @doc """
  Returns the identity matrix which can be used as the starting point in
  building a transform.
  """
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
  def translate t, x, y \\ 0, z \\ 0 do
    op =
    [
      [ 1.0, 0.0, 0.0,   x ],
      [ 0.0, 1.0, 0.0,   y ],
      [ 0.0, 0.0, 1.0,   z ],
      [ 0.0, 0.0, 0.0, 1.0 ]
    ]
    ExMatrix.pmultiply t, op
  end

  @doc """
  Appends a specified scale to the transform. A scaling factor can be provided
  for the x, y and z directions. Defaults if not provided are a scaling factor
  of 1.0.
  """
  def scale t, x, y \\ 1.0, z \\ 1.0 do
    op =
    [
      [   x, 0.0, 0.0, 0.0 ],
      [ 0.0,   y, 0.0, 0.0 ],
      [ 0.0, 0.0,   z, 0.0 ],
      [ 0.0, 0.0, 0.0, 1.0 ]
    ]
    ExMatrix.pmultiply t, op
  end

  def rotate_x t, alpha, units \\ :degrees do
    { sin, cos } = sin_cos alpha, units
    op =
    [
      [ 1.0,  0.0,  0.0, 0.0 ],
      [ 0.0,  cos, -sin, 0.0 ],
      [ 0.0,  sin,  cos, 0.0 ],
      [ 0.0,  0.0,  0.0, 1.0 ]
    ]
    ExMatrix.pmultiply t, op
  end

  def rotate_y t, alpha, units \\ :degrees do
    { sin, cos } = sin_cos alpha, units
    op =
    [
      [  cos,  0.0,  sin, 0.0 ],
      [  0.0,  1.0,  0.0, 0.0 ],
      [ -sin,  0.0,  cos, 0.0 ],
      [  0.0,  0.0,  0.0, 1.0 ]
    ]
    ExMatrix.pmultiply t, op
  end

  def rotate_z t, alpha, units \\ :degrees do
    { sin, cos } = sin_cos alpha, units
    op =
    [
      [ cos, -sin, 0.0, 0.0 ],
      [ sin,  cos, 0.0, 0.0 ],
      [ 0.0,  0.0, 1.0, 0.0 ],
      [ 0.0,  0.0, 0.0, 1.0 ]
    ]
    ExMatrix.pmultiply t, op
  end

  def transform t, x, y \\ 0, z \\ 0 do
    r = [x, y, z, 1]
    t |> Enum.map(&(ExMatrix.dot_product(&1,r)))
      |> Enum.take(3)
  end

  # Converts the angle based on units specified by user and returns
  # the sin and cos for the angle. This is a helper function for the
  # rotate transforms.
  defp sin_cos alpha, units do
    angle = case units do
      :degrees -> alpha / 180.0 * :math.pi()
      _ -> alpha
    end
    { :math.sin(angle), :math.cos(angle) }
  end

end
