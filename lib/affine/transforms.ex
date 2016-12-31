defmodule Affine.Transforms do
  @moduledoc """
  This module defines all the basic transforms. These include translate, scale, and rotation for 1, 2 or 3 dimensions.

  The transform library can be accessed at it's lowest level giving the best
  performance and full control to the developer. An example of using the API at
  this level is:

      t_translate = Affine.Transforms.translate ( 3.0, 4.0, 5.0 )
      point = Affine.transform t_translate [ 1.0, 2.0, 3.0 ]
      assert point == [4.0, 6.0, 8.0]

  And to add a transform to the first one:

      t_scale = Affine.Transforms.scale (2.0, 2.0, 2.0)
      t_scale_then_translate = Affine.multiply t_translate, t_scale
      point = Affine.transform t_scale_then_translate [ 1.0, 2.0, 3.0 ]
      assert point == [ 5.0, 8.0, 11.0 ]

  Keep in mind that the order individual transforms are provided to the multiply
  function is important since transforms are not commutative. With the same
  example as above but with t_translate and t_scale reversed, the resulting point is different:

      t_translate_then_scale = Affine.multiply t_scale, t_translate
      point = Affine.transform t_translate_then_scale [ 1.0, 2.0, 3.0 ]
      assert point == [ 8.0, 12.0, 16.0 ]

  The last transform, t_translate, in this case will be the first to be done. Of course,
  the beauty of Affine transforms is that all multiplied transforms are done
  simultaneously but logically, the last transform multiplied is the first to be
  applied.
  """

  # Define the matrix type used to return a transform.
  @type matrix :: [[number]]

  @doc """
  Defines a 1D tranlation transform for variable x.
  """
  @spec translate(number) :: matrix
  def translate(x) do
    [
      [ 1.0,   x ],
      [ 0.0, 1.0 ]
    ]
  end

  @doc """
  Defines a 2D tranlation transform for variables x and y.
  """
  @spec translate(number,number) :: matrix
  def translate(x, y) do
    [
      [ 1.0, 0.0,   x ],
      [ 0.0, 1.0,   y ],
      [ 0.0, 0.0, 1.0 ]
    ]
  end

  @doc """
  Defines a 3D tranlation transform for variables x, y and z.
  """
  @spec translate(number,number,number) :: matrix
  def translate(x, y, z) do
    [
      [ 1.0, 0.0, 0.0,   x ],
      [ 0.0, 1.0, 0.0,   y ],
      [ 0.0, 0.0, 1.0,   z ],
      [ 0.0, 0.0, 0.0, 1.0 ]
    ]
  end

  @doc """
  Defines a 1D scale transform for variable x.
  """
  @spec scale(number) :: matrix
  def scale(x) do
    [
      [   x, 0.0 ],
      [ 0.0, 1.0 ]
    ]
  end

  @doc """
  Defines a 2D scale transform for variables x and y.
  """
  @spec scale(number,number) :: matrix
  def scale(x, y) do
    [
      [   x, 0.0, 0.0 ],
      [   y, 1.0, 0.0 ],
      [ 0.0, 0.0, 1.0 ]
    ]
  end

  @doc """
  Defines a 3D scale transform for variables x, y and z.
  """
  @spec scale(number,number,number) :: matrix
  def scale(x, y, z) do
    [
      [   x, 0.0, 0.0, 0.0 ],
      [ 0.0,   y, 0.0, 0.0 ],
      [ 0.0, 0.0,   z, 0.0 ],
      [ 0.0, 0.0, 0.0, 1.0 ]
    ]
  end


  @doc """
  Defines a 3d rotation around the x axis in the counter clockwise direction for
  the specified angle in radians.
  """
  @spec rotate_x(number) :: matrix
  def rotate_x angle do
    { sin, cos } = sin_cos angle
    [
      [ 1.0,  0.0,  0.0, 0.0 ],
      [ 0.0,  cos, -sin, 0.0 ],
      [ 0.0,  sin,  cos, 0.0 ],
      [ 0.0,  0.0,  0.0, 1.0 ]
    ]
  end

  @doc """
  Defines a 3d rotation around the y axis in the counter clockwise direction for
  the specified angle in radians.
  """
  @spec rotate_y(number) :: matrix
  def rotate_y angle do
    { sin, cos } = sin_cos angle
    [
      [  cos,  0.0,  sin, 0.0 ],
      [  0.0,  1.0,  0.0, 0.0 ],
      [ -sin,  0.0,  cos, 0.0 ],
      [  0.0,  0.0,  0.0, 1.0 ]
    ]
  end

  @doc """
  Defines a 3d rotation around the z axis in the counter clockwise direction for
  the specified angle in radians.
  """
  @spec rotate_z(number) :: matrix
  def rotate_z angle do
    { sin, cos } = sin_cos angle
    [
      [ cos, -sin, 0.0, 0.0 ],
      [ sin,  cos, 0.0, 0.0 ],
      [ 0.0,  0.0, 1.0, 0.0 ],
      [ 0.0,  0.0, 0.0, 1.0 ]
    ]
  end

  @doc """
  Defines a 2d otation around in the xy plane and is only for a 2D transformation.
  Rotation is in the counter clockwise direction for
  the specified angle in radians.
  """
  @spec rotate_xy(number) :: matrix
  def rotate_xy angle do
    { sin, cos } = sin_cos angle
    [
      [ cos, -sin, 0.0 ],
      [ sin,  cos, 0.0 ],
      [ 0.0,  0.0, 1.0 ]
    ]
  end

  # Converts the angle based on units specified by user and returns
  # the sin and cos for the angle. This is a helper function for the
  # rotate transforms.
  defp sin_cos angle do
    { :math.sin(angle), :math.cos(angle) }
  end

end
