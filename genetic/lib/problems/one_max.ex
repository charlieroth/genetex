defmodule Problems.OneMax do
  @behaviour Problem

  alias Types.Chromose

  @impl Problem
  def genotype() do
    genes = for _ <- 1..42, do: Enum.random(0..1) 
    %Chromose{genes: genes, size: 42}
  end

  @impl Problem
  def fitness(chromose) do
    Enum.sum(chromose.genes)
  end

  @impl Problem
  def terminate?([best | _]) do
    best.fitness() == 42
  end
end
