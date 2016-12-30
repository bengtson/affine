# Affine Transform

This module performs Affine Transforms for 1, 2 and 3 dimensions. The
implementation is simple in this initial version allowing for translation,
scaling and rotation.

An example of usage is:

    t = Affine.identity
    |> Affine.translate([1, 2, 3])
    |> Affine.scale([2, 2, 2])
    |> Affine.rotate_z(90.0, :degrees)

    point = Affine.transform(t, [4, 5, 6])

As the transform is built before being applied, the order of the operations
is reversed as is typical for an Affine Transform. In this case, the point
(4, 5, 6) is first rotated about the z axis, then scaled by 2 in each
direction followed by a translation of (1, 2, 3). The result will be the
point (-9.0, 10.0, 15.0).

The transform matrix is always 4x4 regardless whether it's used for 1, 2 or 3 dimensions.

The following shows how a one-dimensional transform can be used. In this case, only a translate and scale can be applied.

    t = Affine.identity
    |> Affine.translate([1.0,0,0])
    |> Affine.scale([2.0,0,0])

    point_in = [5,0,0]
    point_out = Affine.transform(t,p)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `affine` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:affine, "~> 0.1.0"}]
    end
    ```

## Road Map

Allow for the generation of a transform that does not have the 'reverse' order
effect. It would be created as follows:

    transform =
      |> Affine.Generator.build(3)
      |> Affine.Generator.append(translate([1.0,0,0]))
      |> Affine.Generator.append(scale([2.0,2.0,2.0]))
      |> Affine.Generator.append(rotate_z(45.0))
      |> Affine.Generator.generate

The build function takes takes a diminsions parameter. This can be from 1-3. It
returns a state that tracks all the requested transforms but does not multiply
them until requested by the generate call. The final transform for the code
above will sequentially apply the translate, the scale and the rotate in that order. It will not be reversed.

### Coding state

Clean up Affine.transform. Likely could use a transpose instead of the structuring and destructuring.
Allow for matrices of any size from 1-3 dimensions sizes 2-4.
