defmodule HelloWeb.HelloHTML do
  use HelloWeb, :html

  # Function components are great for smaller templates
  #   def index(assigns) do
  #     ~H"""
  #     Hello!
  #     """
  # end

  # Embed templates are useful for larger templates or when you want to keep your code organized
  embed_templates "hello_html/*"
end
