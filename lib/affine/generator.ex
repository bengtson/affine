defmodule Affine.Generator do

  def build dimensions do
    %{ :size => dimensions, :chain => [] }
  end

  def append build_state, transform do
    chain = build_state[:chain]
    put_in(build_state, [:chain], [transform] ++ chain)
  end

  def generate build_state do
    IO.inspect build_state
    size = build_state[:size] + 1
    identity = Affine.identity
      build_state[:chain]
      |> Enum.reverse
      |> Enum.reduce(identity,&(Matrix.mult(&2,&1)))
  end

end
