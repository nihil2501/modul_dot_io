defmodule ModulDotIo.System do
  alias ModulDotIo.System.{Io, LinkForming, Links}

  def state do
    Links.start()
    LinkForming.start()
    Links.get()
  end
end
