defmodule Problem do
  alias Type.Chromose
  
  @callback genotype() :: Chromose.t()
  @callback fitness(Chromose.t()) :: number()
  @callback terminate?(Enum.t()) :: boolean()
end
