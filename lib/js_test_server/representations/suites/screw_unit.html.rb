module JsTestServer
  module Representations
    module Suites
      class ScrewUnit < JsTestServer::Representations::Suite
        class << self
          def jquery_js_file
            @jquery_js_file ||= "/framework/jquery-1.3.2.js"
          end
          attr_writer :jquery_js_file
        end

        needs :spec_files
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
          script :src => jquery_js_file
          script :src => "/js_test_server.js"
          script :src => "/framework/jquery.fn.js"
          script :src => "/framework/jquery.print.js"
          script :src => "/framework/screw.builder.js"
          script :src => "/framework/screw.matchers.js"
          script :src => "/framework/screw.events.js"
          script :src => "/framework/screw.behaviors.js"
          script :src => "/js_test_server/screw_unit_driver.js"
        end

        def jquery_js_file
          self.class.jquery_js_file
        end

        def body_content
          div :id => "screw_unit_content"
        end
      end
    end
  end
end