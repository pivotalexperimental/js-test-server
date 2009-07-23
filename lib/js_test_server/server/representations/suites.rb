module JsTestServer::Server::Representations::Suites
end

Dir["#{File.dirname(__FILE__)}/suites/*.html.rb"].each do |file|
  require file
end