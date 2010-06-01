class JsTestServer::Server::Views::Suites::Jasmine < JsTestServer::Server::Views::Suite
  needs :spec_files, :framework_path
  attr_reader :spec_files, :framework_path

  def title_text
    "Jasmine suite"
  end

  def head_content
    core_js_files
    project_js_files
    link :rel => "stylesheet", :href => "/framework/jasmine.css"
    project_css_files
    spec_script_elements
    javascript "JsTestServer.JasmineDriver.init();"

  end

  def core_js_files
    jasmine_file = File.basename(Dir["#{framework_path}/jasmine*.js"].sort.last)
    javascript :src => "/framework/#{jasmine_file}"
    javascript :src => "/framework/TrivialReporter.js"
    javascript :src => "/js_test_server.js"
    javascript :src => "/js_test_server/jasmine_driver.js"
  end

  def body_content
    div :id => "jasmine_content"
  end
end
