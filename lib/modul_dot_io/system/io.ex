defmodule ModulDotIo.System.Io do
  keys = [:channel, :direction]
  @enforce_keys keys
  defstruct keys
end
