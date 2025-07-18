defmodule HelloWeb.HelloController do
  use HelloWeb, :controller

  def index(conn, _params) do
    # text(conn, "Hello, World!")
    render(conn, :index)
  end
end
