class JsTestServer::Server::Resources::ImplementationsDeprecation < JsTestServer::Server::Resources::Resource
  map "/implementations"

  get "*" do
    new_path = JsTestServer::Server::Resources::File.path("javascripts", *params["splat"])
    [301, {'Location' => new_path}, "This page has been moved to #{new_path}"]
  end
end