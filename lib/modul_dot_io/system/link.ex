defmodule ModulDotIo.System.Link do
  keys = [:input_io, :output_io]
  @enforce_keys keys
  defstruct keys
end
