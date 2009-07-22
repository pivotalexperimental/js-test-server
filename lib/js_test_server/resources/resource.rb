module JsTestServer
  module Resources
    class Resource < LuckyLuciano::Resource
      protected
      
      def spec_path; server.spec_path; end
      def root_path; server.root_path; end
      def framework_path; server.framework_path; end
      def root_url; server.root_url; end

      def server
        JsTestServer::Configuration
      end
    end
  end
end