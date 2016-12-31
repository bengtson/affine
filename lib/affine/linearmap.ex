defmodule Affine.LinearMap do
  @moduledoc """
  Generating 2D graphics, either for charting, design or other reasons, can require reassignment of a space on the drawing canvas for a part of the graphic.
  For instance, creating the x-axis in a chart that goes for 0-21 for the data in the area from pixel 143 to pixel 200 on the drawing canvas can use a transform to easily convert from data space to canvas space.

  A special type of 'create' parameter list can be used to generate the transform for the very example just stated. Here's how it looks:

      t =
        [type: :linear_map, x1_in: 0.0, x1_out: 143.0, x2_in: 21.0, x2_out: 200.0]
        |> Affine.create

  This code generates a 1D transform with translation and scaling such that a value of 0 in will generate 143 and a value of 21 in will generate a 200.

      point = Affine.map (t, 0.0)
      assert point == 143
      point = Affine.map (t, 21.0)
      assert point == 200
  """

  @type matrix :: [[number]]

  @doc """
  Generates a linear map transform from parameters describing the requried
  mapping. See the documentation above for the format of the parameters
  keyword list. A transform is returned that can perform the mapping.
  """
  @spec linear_map(list) :: matrix
  def linear_map parms do
    y1 = parms[:x1_out]
    y2 = parms[:x2_out]
    x1 = parms[:x1_in]
    x2 = parms[:x2_in]

    slope = (y2-y1)/(x2-x1)
    intercept = y2 - slope * x2

    [ [ type: :scale, dimensions: 1, x: slope],
      [ type: :translate, dimensions: 1, x: intercept] ]
      |> Affine.create
  end

  @doc """
  Given a 1 dimensional transform set up using the Affine.create function
  using the :linear_map type, the map function will map an input value to
  an output value. See the description above for examples.
  """
  @spec map(matrix,number) :: number
  def map t, value do
    t |> Affine.t([value]) |> List.first
  end

end
