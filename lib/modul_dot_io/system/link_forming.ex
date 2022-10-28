defmodule ModulDotIo.System.LinkForming do
  use Agent

  alias ModulDotIo.System.{Io, Link, Patch}

  def start, do: Agent.start(fn -> %MapSet{} end, name: __MODULE__)

  def deselect_io(%Io{direction: :output} = io), do: remove_output_io(io)
  def deselect_io(%Io{direction: :input}) do end

  def select_io(%Io{direction: :output} = io), do: add_output_io(io)
  def select_io(%Io{direction: :input} = input_io) do
    with [%Io{} = output_io] <- get_output_ios() do
      link = %Link{input_io: input_io, output_io: output_io}
      Patch.toggle_link(link)
    end
  end

  defp remove_output_io(io) do
    change_output_ios(&MapSet.delete(&1, io))
  end

  defp add_output_io(io) do
    change_output_ios(&MapSet.put(&1, io))
  end

  defp change_output_ios(change) do
    Agent.update(__MODULE__, change)
  end

  defp get_output_ios do
    Agent.get(__MODULE__, &MapSet.to_list/1)
  end
end
