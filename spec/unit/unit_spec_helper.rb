require "rubygems"
require "spec"
require "spec/autorun"
require "rack/test"
require "rr"
ARGV.push("-b", "--format", "nested")

dir = File.dirname(__FILE__)
LIBRARY_ROOT_DIR = File.expand_path("#{dir}/../..")
$LOAD_PATH.unshift File.expand_path("#{LIBRARY_ROOT_DIR}/lib")
require "js_test_server"
require "nokogiri"
require "guid"
require "thin"
require "js_test_server"
require "#{LIBRARY_ROOT_DIR}/spec/spec_helpers/be_http"
require "#{LIBRARY_ROOT_DIR}/spec/spec_helpers/wait_for"
require "#{LIBRARY_ROOT_DIR}/spec/spec_helpers/example_group"
require "#{LIBRARY_ROOT_DIR}/spec/spec_helpers/fake_selenium_driver"
require "#{LIBRARY_ROOT_DIR}/spec/spec_helpers/show_test_exceptions"
require "#{LIBRARY_ROOT_DIR}/spec/spec_helpers/fake_deferrable"
require "#{LIBRARY_ROOT_DIR}/spec/spec_helpers/mock_session"

Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end

Sinatra::Application.use ShowTestExceptions
Sinatra::Application.set :raise_errors, true
Sinatra::Application.set :show_exceptions, false
JsTestServer::Server::App.set :raise_errors, true
JsTestServer::Server::App.set :show_exceptions, false

Sinatra::Application.use(JsTestServer::Server::App)