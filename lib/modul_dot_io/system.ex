defmodule ModulDotIo.System do
  alias ModulDotIo.System.{Io, LinkForming, Patch}

  def run do
    Patch.start()
    LinkForming.start()
    Patch.get_links() |> IO.inspect()
  end
end
