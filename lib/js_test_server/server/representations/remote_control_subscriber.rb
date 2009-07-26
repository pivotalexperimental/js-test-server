module JsTestServer
  module Server
    module Representations
      class RemoteControlSubscriber < JsTestServer::Server::Representations::Page
        def head_content
          javascript :src => "/js_test_server.js"
          javascript :src => "/js_test_server/remote_control.js"
          javascript "JsTestServer.RemoteControl.start();"
        end

        def body_content
          a "Messages", :href => Resources::RemoteControl.path("messages"), :id => "messages"
        end
      end
    end
  end
end
