defmodule Genetic do
  @moduledoc """
  Documentation for `Genetic`.
  """

  def run(fitness_fn, genotype_fn, max_fitness) do
    population = initialize(genotype_fn) 
    population
    |> evolve(fitness_fn, genotype_fn, max_fitness)
  end

  def initialize(geneotype_fn) do
    for _ <- 1..100, do: geneotype_fn.()
  end

  def evolve(population, fitness_fn, genotype_fn, max_fitness) do
    population = evaluate(population, fitness_fn)
    best = hd(population)
    IO.puts("Current Best: #{fitness_fn.(best)}")
    if fitness_fn.(best) == max_fitness do
      best
    else
      population
      |> select()
      |> crossover()
      |> mutate()
      |> evolve(fitness_fn, genotype_fn, max_fitness)
    end
  end

  def evaluate(population, fitness_fn) do
    population
    |> Enum.sort_by(fitness_fn, &>=/2)
  end

  def select(population) do
    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end

  def crossover(population) do
    population
    |> Enum.reduce([], fn {p1, p2}, acc ->
      cx_point = :rand.uniform(length(p1))
      {{h1, t1}, {h2, t2}} = 
        {Enum.split(p1, cx_point), Enum.split(p2, cx_point)}
      {c1, c2} = {h1 ++ t2, h2 ++ t1}
      [c1, c2 | acc]
    end)
  end

  def mutate(population) do
    population
    |> Enum.map(fn chromose ->
      if :rand.uniform() < 0.05 do
        Enum.shuffle(chromose)
      else
        chromose
      end
    end)
  end
end
