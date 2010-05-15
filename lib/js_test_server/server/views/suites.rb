module JsTestServer::Server::Views::Suites
end

Dir["#{File.dirname(__FILE__)}/suites/*.html.rb"].each do |file|
  require file
end