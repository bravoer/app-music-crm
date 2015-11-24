defmodule Dispatcher do
  use Plug.Router

  def start(_argv) do
    port = 80
    IO.puts "Starting Plug with Cowboy on port #{port}"
    Plug.Adapters.Cowboy.http __MODULE__, [], port: port
    :timer.sleep(:infinity)
  end

  plug Plug.Logger
  plug :match
  plug :dispatch

  match "/accounts/*path" do
    Proxy.forward conn, path, "http://registration/accounts/"
  end

  match "/sessions/*path" do
    Proxy.forward conn, path, "http://login/sessions/"
  end

	match "/scores/*path" do
    Proxy.forward conn, path, "http://resource/scores/"
  end

  match "/parts/*path" do
    Proxy.forward conn, path, "http://resource/parts/"
  end

  match "/files/*path" do
    Proxy.forward conn, path, "http://file/files/"
  end

  match _ do
    send_resp( conn, 404, "Route not found" )
  end

end
