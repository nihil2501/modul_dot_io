defmodule ModulDotIo.System.Links do
  use GenServer

  def start do
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def get do
    links = GenServer.call(__MODULE__, :get)
    {:ok, links}
  end

  def toggle_link(link) do
    links = GenServer.call(__MODULE__, {:toggle_link, link})
    {:ok, links}
  end

  def handle_call({:toggle_link, link}, _from, links) do
    output_channel_update =
      fn channel ->
        next_channel = link.output_io.channel
        if next_channel != channel do
          {channel, next_channel}
        else
          :pop
        end
      end

    input_channel = link.input_io.channel
    {_, next_links} =
      Map.get_and_update(
        links,
        input_channel,
        output_channel_update
      )

    {:reply, next_links, next_links}
  end

  def handle_call(:get, _from, links) do
    {:reply, links, links}
  end

  def init(:ok) do
    {:ok, %{}}
  end
end
