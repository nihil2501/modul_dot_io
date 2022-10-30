defmodule ModulDotIo.System.LinkForming do
  use GenServer

  alias ModulDotIo.System.{Io, Link}

  def start do
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def select_io(%Io{direction: :output} = io) do
    GenServer.cast(__MODULE__, {:add, io})
    {:error, :no_link_formed}
  end

  def select_io(%Io{direction: :input} = input_io) do
    output_ios = GenServer.call(__MODULE__, :get)
    case output_ios do
      [%Io{} = output_io] ->
        link = %Link{input_io: input_io, output_io: output_io}
        {:ok, link}
      _ ->
        {:error, :no_link_formed}
    end
  end

  def deselect_io(%Io{direction: :output} = io) do
    GenServer.cast(__MODULE__, {:remove, io})
    {:error, :no_link_formed}
  end

  def deselect_io(%Io{direction: :input}) do
    {:error, :no_link_formed}
  end

  def handle_cast({:add, io}, output_ios) do
    {:noreply, MapSet.put(output_ios, io)}
  end

  def handle_cast({:remove, io}, output_ios) do
    {:noreply, MapSet.delete(output_ios, io)}
  end

  def handle_call(:get, _from, output_ios) do
    {:reply, MapSet.to_list(output_ios), output_ios}
  end

  def init(:ok) do
    {:ok, %MapSet{}}
  end
end
