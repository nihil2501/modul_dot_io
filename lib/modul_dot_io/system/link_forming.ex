defmodule ModulDotIo.System.LinkForming do
  use Agent

  alias ModulDotIo.System.{Io, Link, Patch}

  def start, do: Agent.start(fn -> [] end, name: __MODULE__)

  def deselect_io(%Io{direction: :output} = io), do: unset_output_io(io)
  def deselect_io(%Io{direction: :input}) do end

  def select_io(%Io{direction: :output} = io), do: set_output_io(io)
  def select_io(%Io{direction: :input} = input_io) do
    with %Io{} = output_io <- get_output_io() do
      link = %Link{input_io: input_io, output_io: output_io}
      Patch.toggle_link(link)
    end
  end

  defp unset_output_io(io) do
    get_and_update_output_io(fn current_io ->
      if(io == current_io, do: :pop, else: {current_io, current_io})
    end)
  end

  defp set_output_io(io) do
    get_and_update_output_io(fn current_io ->
      if(current_io, do: {current_io, current_io}, else: {current_io, io})
    end)
  end

  defp get_output_io do
    get = &Keyword.get(&1, :output_io)
    Agent.get(__MODULE__, get)
  end

  defp get_and_update_output_io(fun) do
    Agent.update(__MODULE__, fn state ->
      {_, next_state} = Keyword.get_and_update(state, :output_io, fun)
      next_state
    end)
  end
end
