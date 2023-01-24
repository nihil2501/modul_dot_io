# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ModulDotIo.Repo.insert!(%ModulDotIo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

if Mix.env() == :dev do
  import ChannelIos, only: [channel_ios: 0]
  alias ModulDotIo.System

  random_links = fn ->
    channels =
      Enum.group_by(
        channel_ios(),
        &elem(&1, 1).direction,
        &elem(&1, 1).channel
      )

    channels.input
    |> Enum.reject(&(&1 && Enum.random([true, true, true, false])))
    |> Map.new(fn input ->
      output = Enum.random(channels.output)
      {input, output}
    end)
  end

  for name <- ["liveset 2020-01-01", "rockband", "video jockey"] do
    System.create_patch(%{
      links: random_links.(),
      name: name
    })
  end
end
