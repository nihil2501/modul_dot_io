defmodule ModulDotIoWeb.PageLiveTest do
  use ModulDotIoWeb.ConnCase
  import Phoenix.LiveViewTest

  test "connected mount", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")
    assert html =~ "keyboard"
  end
end
