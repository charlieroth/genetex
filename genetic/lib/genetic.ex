defmodule Genetic do
  @moduledoc """
  Documentation for `Genetic`.
  """

  def run(fitness_fn, genotype_fn, max_fitness, opts \\ []) do
    population = initialize(genotype_fn, opts) 
    population
    |> evolve(fitness_fn, genotype_fn, max_fitness, opts)
  end

  def initialize(geneotype_fn, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: geneotype_fn.()
  end

  def evolve(population, fitness_fn, genotype_fn, max_fitness, opts \\ []) do
    population = evaluate(population, fitness_fn)
    best = hd(population)
    IO.puts("Current Best: #{fitness_fn.(best)}")
    if fitness_fn.(best) == max_fitness do
      best
    else
      population
      |> select(opts)
      |> crossover(opts)
      |> mutate(opts)
      |> evolve(fitness_fn, genotype_fn, max_fitness, opts)
    end
  end

  def evaluate(population, fitness_fn, opts \\ []) do
    population
    |> Enum.sort_by(fitness_fn, &>=/2)
  end

  def select(population, opts \\ []) do
    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end

  def crossover(population, opts \\ []) do
    population
    |> Enum.reduce([], fn {p1, p2}, acc ->
      cx_point = :rand.uniform(length(p1))
      {{h1, t1}, {h2, t2}} = 
        {Enum.split(p1, cx_point), Enum.split(p2, cx_point)}
      {c1, c2} = {h1 ++ t2, h2 ++ t1}
      [c1, c2 | acc]
    end)
  end

  def mutate(population, opts \\ []) do
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
