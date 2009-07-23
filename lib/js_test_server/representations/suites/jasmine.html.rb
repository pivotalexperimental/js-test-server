module JsTestServer
  module Representations
    module Suites
      class Jasmine < JsTestServer::Representations::Suite
        needs :spec_files
        def title_text
          "Jasmine suite"
        end

        def head_content
          core_js_files
          project_js_files
          link :rel => "stylesheet", :href => "/framework/jasmine.css"
          project_css_files
          spec_script_elements
          script <<-JS
            JsTestServer.JasmineDriver.init();
          JS

        end

        def core_js_files
          script :src => "/framework/jasmine.js"
          script :src => "/framework/TrivialReporter.js"
          script :src => "/framework/screw-jasmine-compat.js"
          script :src => "/js_test_server.js"
          script :src => "/js_test_server/jasmine_driver.js"
        end

        def body_content
          div :id => "jasmine_content"
        end
      end
    end
  end
end