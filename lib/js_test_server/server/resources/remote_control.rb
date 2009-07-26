module JsTestServer
  module Server
    module Resources
      class RemoteControl < JsTestServer::Server::Resources::Resource
        class << self
          def queue
            @queue ||= []
          end
        end

        map "/remote_control"

        get "subscriber" do
          [200, {}, Representations::RemoteControlSubscriber.new.to_s]
        end

        post "broadcasts" do
          self.class.queue << params["javascript"]
          [200, {'Content-Type' => "application/json"}, self.class.queue.to_json]
        end

        get "messages" do
          queue_content = self.class.queue.dup
          self.class.queue.clear
          [200, {'Content-Type' => "application/json"}, queue_content.to_json]
        end
      end
    end
  end
end
