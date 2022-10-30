defmodule ModulDotIo.System do
  alias ModulDotIo.System.{Io, LinkForming, Links}

  @channel_ios (
    Map.new(97..122, fn i ->
      channel = String.to_atom(<<i>>)
      output? = Enum.member?(~w(q w e)a, channel)
      direction = if(output?, do: :output, else: :input)
      io = %Io{channel: channel, direction: direction}

      {channel, io}
    end)
  )

  # The information about what direction an Io is set to is only possessed by
  # the Io's. Io's will include it when informing the modul during link-forming,
  # and they also use it locally to determine their own appearance. This should
  # maybe be moved to a different file.
  def channel_ios, do: @channel_ios

  def state do
    Links.start()
    LinkForming.start()
    Links.get()
  end
end
