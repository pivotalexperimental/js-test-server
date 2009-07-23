module JsTestServer
  module Resources
    class WebRoot < File
      map "/"
      
      get("") do
        "<html><head></head><body>Welcome to the Js Test Server. Click the following link to run you <a href=/specs>spec suite</a>.</body></html>"
      end

      get("*") do
        do_get
      end

      protected

      def root_path
        Configuration.js_test_server_root_path
      end
    end
  end
end