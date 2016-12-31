defmodule Affine do
  @moduledoc """
  This library performs affine transforms for multiple dimensions. The
  implementation is simple in this initial version allowing for translation,
  scaling, shear and rotation.

  This library uses the Matrix library available on Hex. It is automatically included when using this library as a dep in your application.

  ## Using The Affine Library

  The capabilities of the library can be accessed through either a low level api or a higher level one.

  ### Low Level API

  The transform library can be accessed at it's lowest level giving the best
  performance and full control to the developer. An example of using the API at
  this level is:

      t_translate = Affine.Transforms.translate (3.0, 4.0, 5.0)
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

  ### High Level API

  The easier API for creating and using Affine transforms uses the flexibility
  provided in Elixir to more elegantly define the transforms. This requires a bit more processing but generally would not be a burden to the application unless
  many transforms are being created. Here's an example:

      t_translate = Affine.create [ type: :translate, dimensions: 3, x: 3.0, y: 4.0, z: 5.0]
      point = Affine.transform t_translate [ 1.0, 2.0, 3.0]
      assert point == [4.0, 6.0, 8.0]

  So the create function takes a parameter list and generates the correct
  transform. The create function can also take a list of parameter lists and
  generate a single transform from those parameter lists. For example, to create,
  t_translate_then_scale with a single call to create, the following can be done:

      point =
        [ [type: :translate, dimensions: 3, x: 3.0, y: 4.0, z: 5.0],
          [type: :scale, dimensions: 3, x: 2.0, y: 2.0, z: 2.0] ]
        |> Affine.create
        |> Affine.transform [1.0, 2.0, 3.0]
      assert point == [ 8.0, 12.0, 16.0 ]

  Note the order of transforms in the parameter list is applied such that the first transform in the parameter list is the last one applied to the final transform. Logically, it is the first one to be applied when using the final transform.

  Of course, the above is only useful for a one time point transformation since
  the generate transform is not saved. So the following is likely to be more
  useful:

      t_translate_then_scale =
        [ [type: :translate, dimensions: 3, x: 3.0, y: 4.0, z: 5.0],
          [type: :scale, dimensions: 3, x: 2.0, y: 2.0, z: 2.0] ]
        |> Affine.create

      point = t_translate_then_scale
        |> Affine.transform [1.0, 2.0, 3.0]
      assert point == [ 8.0, 12.0, 16.0 ]

  ### Linear Maps

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
  @type point :: [number]
  @type list_of_specs :: [[]]

  @spec create(list_of_specs) :: matrix
  defdelegate create(parameters), to: Affine.Generator, as: :create

  @spec m(matrix,matrix) :: matrix
  defdelegate m(matrix1,matrix2), to: Affine.Operations, as: :multiply

  @spec multiply(matrix,matrix) :: matrix
  defdelegate multiply(matrix1,matrix2), to: Affine.Operations, as: :multiply

  @spec t(matrix,point) :: point
  defdelegate t(matrix,point), to: Affine.Operations, as: :transform

  @spec transform(matrix,point) :: point
  defdelegate transform(matrix,point), to: Affine.Operations, as: :transform

  @spec map(matrix,number) :: number
  defdelegate map(matrix,value), to: Affine.LinearMap, as: :map

end
