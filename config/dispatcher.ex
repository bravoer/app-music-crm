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

  match "/userprofile/*path" do
    Proxy.forward conn, path, "http://userprofile/userprofile/"
  end

  match "/scores/*path" do
    Proxy.forward conn, path, "http://cache/scores/"
  end

  match "/parts/*path" do
    Proxy.forward conn, path, "http://cache/parts/"
  end

  match "/musicians/*path" do
    Proxy.forward conn, path, "http://cache/musicians/"
  end

  match "/sympathizers/*path" do
    Proxy.forward conn, path, "http://cache/sympathizers/"
  end

  match "/addresses/*path" do
    Proxy.forward conn, path, "http://cache/addresses/"
  end

  match "/telephones/*path" do
    Proxy.forward conn, path, "http://cache/telephones/"
  end

  match "/events/*path" do
    Proxy.forward conn, path, "http://cache/events/"
  end

  match "/sponsorships/*path" do
    Proxy.forward conn, path, "http://cache/sponsorships/"
  end

  match "/musician-groups/*path" do
    Proxy.forward conn, path, "http://cache/musician-groups/"
  end
  
  match "/authenticatables/*path" do
    Proxy.forward conn, path, "http://authorization/authenticatables/"
  end

  match "/users/*path" do
    Proxy.forward conn, path, "http://authorization/users/"
  end

  match "/user-groups/*path" do
    Proxy.forward conn, path, "http://authorization/user-groups/"
  end

  match "/access-tokens/*path" do
    Proxy.forward conn, path, "http://authorization/access-tokens/"
  end

  match "/grants/*path" do
    Proxy.forward conn, path, "http://authorization/grants/"
  end
	
  match "/files/*path" do
    Proxy.forward conn, path, "http://file/files/"
  end

  match "/export/*path" do
    Proxy.forward conn, path, "http://export/"
  end

  match "/label-printer/*path" do
    Proxy.forward conn, path, "http://labels/"
  end

  match _ do
    send_resp( conn, 404, "Route not found" )
  end

end
