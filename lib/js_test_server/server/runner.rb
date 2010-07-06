class JsTestServer::Server::Runner
  include JsTestServer::Server
  def cli(*argv)
    opts = Trollop.options(argv) do
      opt(
        :framework_name,
        "The name of the test framework you want to use. e.g. --framework-name=jasmine",
        :type => String,
        :default => DEFAULTS[:framework_name]
      )
      opt(
        :framework_path,
        "The name of the test framework you want to use. e.g. --framework-path=./specs/jasmine_core",
        :type => String,
        :default => DEFAULTS[:framework_path]
      )
      opt(
        :spec_path,
        "The path to the spec files. e.g. --spec-path=./specs",
        :type => String,
        :default => DEFAULTS[:spec_path]
      )
      opt(
        :root_path,
        "The root path of the server. e.g. --root-path=./public",
        :type => String,
        :default => DEFAULTS[:root_path]
      )
      opt(
        :port,
        "The server port",
        :type => Integer,
        :default => DEFAULTS[:port]
      )
      opt(
        :javascript_files,
        "The javascript files under test",
        :type => String,
        :default => ""
      )
      opt(
        :css_files,
        "The css files under test",
        :type => String,
        :default => ""
      )
      opt(
        :javascript_test_file_glob,
        "The glob to find the javascript files",
        :type => String,
        :default => DEFAULTS[:javascript_test_file_glob]
      )
    end

    JsTestServer.port = opts[:port]
    JsTestServer.framework_name = opts[:framework_name]
    JsTestServer.framework_path = opts[:framework_path]
    JsTestServer.spec_path = opts[:spec_path]
    JsTestServer.root_path = opts[:root_path]
    JsTestServer.javascript_test_file_glob = opts[:javascript_test_file_glob]
    suite_view_class = JsTestServer::Configuration.instance.suite_view_class
    suite_view_class.project_js_files.push(*opts[:javascript_files].split(","))
    suite_view_class.project_css_files.push(*opts[:css_files].split(","))
    STDOUT.puts "root-path is #{JsTestServer.root_path}"
    STDOUT.puts "spec-path is #{JsTestServer.spec_path}"
    start
  end

  def start
    require "thin"
    Thin::Runner.new([
      "--port", JsTestServer.port.to_s,
      "--rackup", File.expand_path(JsTestServer.rackup_path),
      "start"]
    ).run!
  end

  def standalone_rackup(rack_builder)
    require "sinatra"

    rack_builder.use JsTestServer::Server::App
    rack_builder.run Sinatra::Application
  end
end