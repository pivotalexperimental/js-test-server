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
          a "Commands", :href => Resources::RemoteControl.path("commands"), :id => "commands"
        end
      end
    end
  end
end
