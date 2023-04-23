defmodule Problem do
  alias Type.Chromose
  
  @callback genotype() :: Chromose.t()
  @callback fitness_fn(Chromose.t()) :: number()
  @callback terminate?(Enum.t()) :: boolean()
end
