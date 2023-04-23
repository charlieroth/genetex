genotype_fn = fn -> 
  for _ <- 1..1000, do: Enum.random(0..1) 
end

fitness_fn = fn chromose ->
  Enum.sum(chromose)
end

max_fitness = 1000

solution = Genetic.run(fitness_fn, genotype_fn, max_fitness)

IO.inspect(solution)
