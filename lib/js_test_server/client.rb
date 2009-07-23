module JsTestServer
  module Client
    RUNNING_RUNNER_STATE = "running"
    PASSED_RUNNER_STATE = "passed"
    FAILED_RUNNER_STATE = "failed"
    FINISHED_RUNNER_STATES = [PASSED_RUNNER_STATE, FAILED_RUNNER_STATE]

    DEFAULT_SELENIUM_BROWSER = "*firefox"
    DEFAULT_SELENIUM_HOST = "0.0.0.0"
    DEFAULT_SELENIUM_PORT = 4444
    DEFAULT_SPEC_URL = "http://localhost:8080/specs"
    DEFAULT_TIMEOUT = 60

    class ClientException < Exception
    end

    class InvalidStatusResponse < ClientException
    end
  end
end

dir = File.dirname(__FILE__)
require "#{dir}/client/runner"
