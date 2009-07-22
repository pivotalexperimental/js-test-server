module JsTestServer
  class App < Sinatra::Base
    set :logging, true
    register(JsTestServer::Resources::WebRoot.route_handler)
    register(JsTestServer::Resources::FrameworkFile.route_handler)
    register(JsTestServer::Resources::SpecFile.route_handler)
    register(JsTestServer::Resources::File.route_handler)
    register(JsTestServer::Resources::ImplementationsDeprecation.route_handler)
    register(JsTestServer::Resources::NotFound.route_handler)
  end
end