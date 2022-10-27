defmodule ModulDotIo.System.LinkForming do
  use Agent

  alias ModulDotIo.System.{Io, Link, Patch}

  def start, do: Agent.start(fn -> [] end, name: __MODULE__)

  def select_io(%Io{direction: :output} = io), do: set_output_io(io)
  def select_io(%Io{direction: :input} = input_io) do
    case get_output_io() do
      %Io{} = output_io ->
        link = %Link{input_io: input_io, output_io: output_io}
        Patch.toggle_link(link)
    end
  end

  def deselect_io(%Io{direction: :output}), do: set_output_io()
  def deselect_io(%Io{direction: :input}) do end

  defp set_output_io(io \\ nil) do
    update =
      case io do
        %Io{} -> &Keyword.put_new(&1, :output_io, io)
        nil -> &Keyword.delete(&1, :output_io)
      end

    Agent.update(__MODULE__, update)
  end

  defp get_output_io do
    get = &Keyword.get(&1, :output_io)
    Agent.get(__MODULE__, get)
  end
end
