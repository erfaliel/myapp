defmodule TestWeb.TestController do
  use TestWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
