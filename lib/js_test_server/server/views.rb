dir = File.dirname(__FILE__)

module JsTestServer::Server::Views
end

require "#{dir}/views/page.html"
require "#{dir}/views/not_found.html"
require "#{dir}/views/suite.html"
require "#{dir}/views/dir.html"
require "#{dir}/views/frameworks"
require "#{dir}/views/suites"
require "#{dir}/views/remote_control_subscriber"
