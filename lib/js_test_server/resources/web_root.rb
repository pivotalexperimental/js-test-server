module JsTestServer
  module Resources
    class WebRoot < Resource
      map "/"
      
      get("") do
        "<html><head></head><body>Welcome to the Js Test Server. Click the following link to run you <a href=/specs>spec suite</a>.</body></html>"
      end

      get("js_test_server.js") do
        File.render_file(Configuration.js_test_server_js_path)
      end
    end
  end
end