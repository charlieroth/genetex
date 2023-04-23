defmodule Genetic do
  @moduledoc """
  Documentation for `Genetic`.
  """

  alias Types.Chromose

  def run(problem, opts \\ []) do
    population = initialize(&problem.genotype/0, opts) 
    population
      |> evolve(problem, opts)
  end

  def initialize(geneotype_fn, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: geneotype_fn.()
  end

  def evolve(population, problem, opts \\ []) do
    population = evaluate(population, &problem.fitness/1, opts)
    best = hd(population)
    IO.puts("Current Best: #{best.fitness}")
    if problem.terminate?(population) do
      best
    else
      population
      |> select(opts)
      |> crossover(opts)
      |> mutate(opts)
      |> evolve(problem, opts)
    end
  end

  def evaluate(population, fitness_fn, opts \\ []) do
    population
    |> Enum.map(fn chromose ->
      fitness = fitness_fn.(chromose)
      age = chromose.age + 1
      %Chromose{chromose | fitness: fitness, age: age}
    end)
    |> Enum.sort_by(&(&1.fitness), &>=/2)
  end

  def select(population, opts \\ []) do
    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end

  def crossover(population, opts \\ []) do
    population
    |> Enum.reduce([], fn {p1, p2}, acc ->
      cx_point = :rand.uniform(length(p1.genes))
      {{h1, t1}, {h2, t2}} = 
        {
          Enum.split(p1.genes, cx_point), 
          Enum.split(p2.genes, cx_point)
        }
      {c1, c2} = {
        %Chromose{p1 | genes: h1 ++ t2}, 
        %Chromose{p2 | genes: h2 ++ t1}
      }
      [c1, c2 | acc]
    end)
  end

  def mutate(population, opts \\ []) do
    population
    |> Enum.map(fn chromose ->
      if :rand.uniform() < 0.05 do
        %Chromose{chromose | 
          genes: Enum.shuffle(chromose.genes)
        }
      else
        chromose
      end
    end)
  end
end
