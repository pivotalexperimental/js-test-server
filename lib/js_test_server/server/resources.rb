dir = File.dirname(__FILE__)

module JsTestServer::Server::Resources
end

require "#{dir}/resources/resource"
require "#{dir}/resources/file"
require "#{dir}/resources/spec_file"
require "#{dir}/resources/framework_file"
require "#{dir}/resources/web_root"
require "#{dir}/resources/not_found"
require "#{dir}/resources/remote_control"

require "#{dir}/resources/implementations_deprecation"
