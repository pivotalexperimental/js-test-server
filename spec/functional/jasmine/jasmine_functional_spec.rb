require File.expand_path("#{File.dirname(__FILE__)}/../functional_spec_helper")

describe JsTestServer do
  start_servers("jasmine")
  attr_reader :stdout, :request
  
  before do
    @stdout = StringIO.new
    JsTestServer::Client.const_set(:STDOUT, stdout)
    @request = "http request"
  end

  after do
    JsTestServer::Client.__send__(:remove_const, :STDOUT)
  end

  it "runs a full passing Suite" do
    JsTestServer::Client::Runner.run(:spec_url => "#{root_url}/specs/passing_spec")
    stdout.string.strip.should include(JsTestServer::Client::PASSED_RUNNER_STATE.capitalize)
  end

  it "runs a full failing Suite" do
    JsTestServer::Client::Runner.run(:spec_url => "#{root_url}/specs/failing_spec")
    stdout.string.strip.should include(JsTestServer::Client::FAILED_RUNNER_STATE.capitalize)
    stdout.string.strip.should include("A failing spec fails")
  end
end
