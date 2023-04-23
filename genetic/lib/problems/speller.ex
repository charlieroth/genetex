defmodule Problems.Speller do
  @behaviour Problem

  alias Types.Chromose

  @impl Problem
  def genotype() do
    genes =
      Stream.repeatedly(fn -> Enum.random(?a..?z) end)
      |> Enum.take(34)

    %Chromose{genes: genes, size: 34}
  end

  @impl Problem
  def fitness(chromose) do
    target = "supercalifragilisticexpialidocious"
    guess = List.to_string(chromose.genes)
    # computes the "similarity" between target and guess
    # 0.0 meaning not similar at all
    # 1.0 meaning the strings are the same
    String.jaro_distance(target, guess)
  end

  @impl Problem
  def terminate?([best | _]) do
    best.fitness == 1 
  end
end
