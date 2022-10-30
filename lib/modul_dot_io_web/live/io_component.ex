defmodule ModulDotIoWeb.IoComponent do
  use ModulDotIoWeb, :component

  alias Phoenix.LiveView.JS
  alias ModulDotIo.System
  alias ModulDotIo.System.Io

  attr :channel, :atom, required: true
  attr :linked_channel, :atom, required: true
  attr :rest, :global

  def io(assigns) do
    ~H"""
    <div
      class={["key--letter" | classes(@channel, @linked_channel)]}
      phx-window-keydown={keydown()}
      phx-window-keyup={keyup()}
      phx-key={@channel}
      {@rest}>
      <%= @channel %>
    </div>
    """
  end

  defp classes(channel, linked_channel) do
    case System.channel_ios()[channel] do
      %Io{direction: :output} ->
        ["channel-output", "channel-#{channel}"]
      %Io{direction: :input} ->
        if linked_channel do
          ["channel-input", "channel-#{linked_channel}"]
        else
          ["channel-input"]
        end
    end
  end

  defp keydown(js \\ %JS{}) do
    js
    |> JS.set_attribute({"data-pressed", "on"})
    |> JS.push("select_io")
  end

  defp keyup(js \\ %JS{}) do
    js
    |> JS.push("deselect_io")
    |> JS.remove_attribute("data-pressed")
  end
end
