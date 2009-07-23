class JsTestServer::Server::App < Sinatra::Base
  set :logging, true
  register(JsTestServer::Server::Resources::WebRoot.route_handler)
  register(JsTestServer::Server::Resources::SpecFile.route_handler)
  register(JsTestServer::Server::Resources::File.route_handler)
  register(JsTestServer::Server::Resources::FrameworkFile.route_handler)
  register(JsTestServer::Server::Resources::ImplementationsDeprecation.route_handler)
  register(JsTestServer::Server::Resources::NotFound.route_handler)
end