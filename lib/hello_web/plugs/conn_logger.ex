defmodule HelloWeb.Plugs.ConnLogger do
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    Logger.debug("""
    === CONNECTION DEBUG ===
    Method: #{conn.method}
    Path: #{conn.request_path}
    Query: #{conn.query_string}
    Headers: #{inspect(conn.req_headers, pretty: true)}
    Params: #{inspect(conn.params, pretty: true)}
    Assigns: #{inspect(conn.assigns, pretty: true)}
    ========================
    """)
    conn
  end
end
