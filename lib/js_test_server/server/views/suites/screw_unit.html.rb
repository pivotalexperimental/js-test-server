class JsTestServer::Server::Views::Suites::ScrewUnit < JsTestServer::Server::Views::Suite
  class << self
    attr_accessor :jquery_js_file
  end

  needs :spec_files, :framework_path
  attr_reader :spec_files, :framework_path

  def title_text
    "Screw Unit suite"
  end

  def head_content
    core_js_files
    project_js_files
    link :rel => "stylesheet", :href => "/framework/screw.css"
    project_css_files

    spec_script_elements
  end

  def core_js_files
    javascript :src => jquery_js_file
    javascript :src => "/js_test_server.js"
    javascript :src => "/framework/jquery.fn.js"
    javascript :src => "/framework/jquery.print.js"
    javascript :src => "/framework/screw.builder.js"
    javascript :src => "/framework/screw.matchers.js"
    javascript :src => "/framework/screw.events.js"
    javascript :src => "/framework/screw.behaviors.js"
    javascript :src => "/js_test_server/screw_unit_driver.js"
  end

  def jquery_js_file
    self.class.jquery_js_file || (
      (jquery_path = Dir["#{framework_path}/jquery-*.js"].sort.last) &&
        "/framework/#{File.basename(jquery_path)}"
    )
  end

  def body_content
    div :id => "screw_unit_content"
  end
end