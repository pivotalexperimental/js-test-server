dir = File.dirname(__FILE__)

module JsTestServer::Server::Representations
end

require "#{dir}/representations/page.html"
require "#{dir}/representations/not_found.html"
require "#{dir}/representations/suite.html"
require "#{dir}/representations/dir.html"
require "#{dir}/representations/frameworks"
require "#{dir}/representations/suites"
require "#{dir}/representations/remote_control_subscriber"
