defmodule ModulDotIoWeb.PatchLive do
  use ModulDotIoWeb, :live_view

  alias ModulDotIo.System

  def mount(_params, _session, socket) do
    links = System.run()
    {:ok, assign(socket, :links, links)}
  end
end
