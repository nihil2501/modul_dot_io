defmodule ModulDotIoWeb.PatchControllerTest do
  use ModulDotIoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "links"
  end
end
