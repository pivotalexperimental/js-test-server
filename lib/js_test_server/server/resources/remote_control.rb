module JsTestServer
  module Server
    module Resources
      class RemoteControl < JsTestServer::Server::Resources::Resource
        TIMEOUT = 30
        POLL_STEP_PERIOD = 0.005
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
          if self.class.queue.empty? && Object.const_defined?(:Thin)
            EM.add_timer(POLL_STEP_PERIOD) {long_poll_do_get_messages(Time.now)}
            throw :async
          else
            do_get_messages
          end
        end

        protected
        def long_poll_do_get_messages(long_poll_start_time)
          if long_poll_start_time && self.class.queue.empty?
            EM.add_timer(POLL_STEP_PERIOD) {long_poll_do_get_messages(long_poll_start_time)}
          else
            env[Thin::Request::ASYNC_CALLBACK].call(do_get_messages)
          end
        end

        def do_get_messages
          queue_content = self.class.queue.dup
          self.class.queue.clear
          [200, {'Content-Type' => "application/json"}, queue_content.to_json]
        end
      end
    end
  end
end
