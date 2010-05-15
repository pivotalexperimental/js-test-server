require "rubygems"
require "timeout"
require "lsof"
dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../../lib"
require "js_test_server"
require "nokogiri"

class FunctionalSpecServerStarter
  include WaitFor

  attr_reader :framework_name
  def initialize(framework_name)
    @framework_name = framework_name
  end

  def call(threaded=true)
    return if $js_test_server_started

    Lsof.kill(8080)
    wait_for do
      !Lsof.running?(8080)
    end

    dir = File.dirname(__FILE__)
    Dir.chdir("#{dir}/../../") do
      Thread.start do
        start_thin_server
      end
    end

    wait_for do
      Lsof.running?(8080)
    end
    $js_test_server_started = true
  end

  def start_thin_server
    system("bin/js-test-server --spec-path=#{spec_path} --root-path=#{root_path} --framework-name=#{framework_name} --framework-path=#{framework_path}")
    at_exit do
      stop_thin_server
    end
  end

  def stop_thin_server
    Lsof.kill(8080)
  end

  def framework_path
    File.expand_path("#{dir}/../frameworks/#{framework_name}/lib")
  end

  def spec_path
    File.expand_path("#{dir}/#{framework_name}/example_spec")
  end

  def root_path
    File.expand_path("#{dir}/../example_root")
  end

  def dir
    dir = File.dirname(__FILE__)
  end
end

if $0 == __FILE__
  FunctionalSpecServerStarter.new(ENV["FRAMEWORK_PATH"] || "jasmine").call(false)
  sleep
end