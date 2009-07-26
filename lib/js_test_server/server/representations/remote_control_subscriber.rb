module JsTestServer
  module Server
    module Representations
      class RemoteControlSubscriber < JsTestServer::Server::Representations::Page
        def script_elements
          #script
        end

        def body_content
          a :href => Resources::RemoteControl.path("messages")
        end
      end
    end
  end
end
