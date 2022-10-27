defmodule ModulDotIoWeb.PatchController do
  use ModulDotIoWeb, :controller

  alias ModulDotIo.System

  def index(conn, _params) do
    links = System.run()
    render(conn, "index.html", links: links)
  end
end
