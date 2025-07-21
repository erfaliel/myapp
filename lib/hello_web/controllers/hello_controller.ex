defmodule HelloWeb.HelloController do
  use HelloWeb, :controller

  def index(conn, _params) do
    # text(conn, "Hello, World!")
    render(conn, :index)
  end

  # def show(conn, %{"messenger" => messenger} = params) do # (if you want to use params)
  def show(conn, %{"messenger" => messenger}) do
    # text(conn, "Hello, #{messenger}!")
    render(conn, :show, messenger: messenger)
  end

end
