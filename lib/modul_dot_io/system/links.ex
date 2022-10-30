defmodule ModulDotIo.System.Links do
  use Agent

  def start do
    Agent.start(fn -> %{} end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, fn links -> links end)
  end

  def toggle_link(link) do
    output_channel_update =
      fn channel ->
        next_channel = link.output_io.channel
        if next_channel != channel do
          {channel, next_channel}
        else
          :pop
        end
      end

    links_update =
      fn links ->
        input_channel = link.input_io.channel
        {_, next_links} =
          Map.get_and_update(
            links,
            input_channel,
            output_channel_update
          )

        next_links
      end

    Agent.update(__MODULE__, links_update)
  end
end
