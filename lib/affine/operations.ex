defmodule Affine.Operations do
  @moduledoc """
  The Operations module simply defines the multiply and transform functions in
  the Matrix library for convienence. Additionally, aliases are provided using 't' for 'transform' and 'm' for 'multiply'.
  """

  @type matrix :: [[number]]
  @type point :: [number]

  @spec t(matrix,point) :: point
  defdelegate t(matrix,point), to: Affine.Operations, as: :transform

  @spec m(matrix,matrix) :: matrix
  defdelegate m(matrix1,matrix2), to: Affine.Operations, as: :multiply

  @doc """
  Transforms the provided point with the specified transform. Returns the
  transformed point. The point may be 1, 2 or 3 dimensional.

  An example of usage is:

      t1 = Affine.Transforms.translate (3.0, 4.0, 5.0)
      t2 = Affine.Transforms.scale (2.0, 2.0, 2.0)
      t = Affine.Operations.multiply t1, t2

      point = Affine.transform t [ 1.0, 2.0, 3.0 ]

  """
  @spec transform(matrix,point) :: point
  def transform t, point do
    r = Matrix.transpose [point++[1]]
    Matrix.mult(t,r)
      |> Enum.drop(-1)
      |> Enum.map(&(List.first(&1)))
  end

  @doc """
  Multiplies two transformations to get a new one. Order of matrix
  multiplication is not communitative; order is important. Effectively,
  the t2 tranform matrix is done first when applying the combined result.

  An example of usage is:

      t_scale = Affine.Transforms.scale (2.0, 2.0, 2.0)
      t_scale_then_translate = Affine.Operations.multiply t_translate, t_scale
      point = Affine.transform t_scale_then_translate [ 1.0, 2.0, 3.0 ]
      assert point == [ 5.0, 8.0, 11.0 ]

  Note that the multiply function is also aliased as Affine.multiply and Affine.m.
  """
  @spec multiply(matrix,matrix) :: matrix
  def multiply t1, t2 do
    Matrix.mult t1, t2
  end

end
