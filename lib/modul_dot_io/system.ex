defmodule ModulDotIo.System do
  alias ModulDotIo.System.{Io, LinkForming, Patch}

  def state do
    Patch.start()
    LinkForming.start()
    Patch.get_links()
  end
end
