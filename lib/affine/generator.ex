defmodule Affine.Generator do
  @moduledoc """
  Module enclosing the high level transform creating capabilities.

  An easy API for creating and using Affine transforms uses the flexibility
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

  Following are all the types of transforms that can be created:

      [type: :translate, dimensions: 1, x: value]
      [type: :translate, dimensions: 2, x: value, y: value]
      [type: :translate, dimensions: 3, x: value, y: value, z: value]

  Where value is the translation value for the x, y and z axis respectively.

      [type: :scale, dimensions: 1, x: value]
      [type: :scale, dimensions: 2, x: value, y: value]
      [type: :scale, dimensions: 3, x: value, y: value, z: value]

  Where value is the scale value for the x, y and z axis respectively.

      [type: :rotate_x, angle: value, units: units]
      [type: :rotate_y, angle: value, units: units]
      [type: :rotate_z, angle: value, units: units]

  These rotations are all for 3 dimensions and rotate around the respectively
  axis in the counter-clockwise direction. Angle is in radians unless units is set to :degrees.

      [type: :rotate_xy, angle: value, units: units]

  This is a 2 dimensional rotate in the xy plane. Angle is in radians unless units is set to :degrees.

      [type: :linear_map, x1_in: value1in, x1_out: value1out, x2_in: value2in, x2_out: value2out]

  See the documentation on the LinearMap module. This defines a convienient 1 dimensional linear map useful for various linear mapping applications.
  """

  @type matrix :: [[number]]
  @type list_of_specs :: [[]]
  @type spec :: []

  @doc """
  Creates all the transformations specified in the format described above and
  returns a final composite transform.

  It can also create a single trasform using the specification format above.
  This is really a helper function for the create function above but it can be
  called directly. For example, the following will return a 3d scale transform:

        Affine.create [type: :scale, dimensions: 3, x: 1.0, y: 2.0, z: 3.0]

  """
  @spec create(list_of_specs) :: matrix
  def create([ head | tail ]) when is_list(head) do
    list = [head] ++ tail
    size = head[:dimensions] + 1
    identity = Matrix.ident(size)
    list
      |> Enum.reverse
      |> Enum.map(&(create &1))
      |> Enum.reduce(identity,&(Matrix.mult(&2,&1)))
  end

  @spec create(spec) :: matrix
  def create parms do
    cond do
      parms[:type] == :translate && parms[:dimensions] == 3 ->
        Affine.Transforms.translate(parms[:x],parms[:y],parms[:z])
      parms[:type] == :translate && parms[:dimensions] == 2 ->
        Affine.Transforms.translate(parms[:x],parms[:y])
      parms[:type] == :translate && parms[:dimensions] == 1 ->
        Affine.Transforms.translate(parms[:x])
      parms[:type] == :scale && parms[:dimensions] == 3 ->
        Affine.Transforms.scale(parms[:x],parms[:y],parms[:z])
      parms[:type] == :scale && parms[:dimensions] == 2 ->
        Affine.Transforms.scale(parms[:x],parms[:y])
      parms[:type] == :scale && parms[:dimensions] == 1 ->
        Affine.Transforms.scale(parms[:x])
      parms[:type] == :rotate_x ->
        Affine.Transforms.rotate_x(radians(parms))
      parms[:type] == :rotate_y ->
        Affine.Transforms.rotate_y(radians(parms))
      parms[:type] == :rotate_z ->
        Affine.Transforms.rotate_z(radians(parms))
      parms[:type] == :rotate_xy ->
        Affine.Transforms.rotate_xy(radians(parms))
      parms[:type] == :linear_map ->
        Affine.LinearMap.linear_map(parms)
      true ->
        nil
    end
  end

  # Returns radians given the parameters in a transform specification list. If
  # units: :degrees is used in the spec, then it is converted to radians and
  # returned.
  defp radians parms do
    units = parms[:units]
    angle = parms[:angle]
    case units do
      :degrees -> angle / 180.0 * :math.pi()
      _ -> angle
    end
  end

end
