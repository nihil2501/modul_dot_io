defmodule ModulDotIo.System.Links do
  use Agent

  def start do
    Agent.start(fn -> %{} end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, fn links -> links end)
  end

  def toggle_link(link) do
    channel_update =
      fn channel ->
        if link.output_io.channel == channel do
          :pop
        else
          {channel, link.output_io.channel}
        end
      end

    links_update =
      fn links ->
        {_, next_links} =
          Map.get_and_update(
            links,
            link.input_io.channel,
            channel_update
          )

        next_links
      end

    Agent.update(__MODULE__, links_update)
  end
end