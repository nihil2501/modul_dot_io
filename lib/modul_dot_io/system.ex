defmodule ModulDotIo.System do
  alias ModulDotIo.System.{Io, LinkForming, Patch}

  def run do
    Patch.start()
    LinkForming.start()

    output_io = %Io{channel: 1, direction: :output}
    LinkForming.select_io(output_io)

    input_io = %Io{channel: 2, direction: :input}
    LinkForming.select_io(input_io)

    Patch.get_links()
  end
end
