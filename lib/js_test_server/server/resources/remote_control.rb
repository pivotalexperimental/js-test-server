module JsTestServer
  module Server
    module Resources
      class RemoteControl < JsTestServer::Server::Resources::Resource
        class Queue
          def initialize
            @items = []
            @subscriber = nil
          end
          def push item
            @items << item
            notify_subscriber if @subscriber
          end
          alias :<< :push
          def subscribe &blk
            @subscriber = blk
            notify_subscriber unless @items.empty?
          end
          def unsubscribe
            @subscriber = nil
          end
          def clear
            items, @items = @items, []
            items
          end
          def to_a
            @items
          end
          
          protected

          def notify_subscriber
            @subscriber.call
            unsubscribe
          end
        end

        class << self
          def queue
            @queue ||= Queue.new
          end
          attr_writer :queue
        end

        map "/remote_control"

        get "subscriber" do
          [200, {}, Representations::RemoteControlSubscriber.new.to_s]
        end

        post "commands" do
          self.class.queue << {"javascript" => params["javascript"]}
          [200, {'Content-Type' => "application/json"}, self.class.queue.to_a.to_json]
        end

        get "commands" do
          if Object.const_defined?(:Thin)
            subscribed = true
            self.class.queue.subscribe do
              subscribed = false
              env[Thin::Request::ASYNC_CALLBACK].call(do_get_commands)
            end
            env[Thin::Request::ASYNC_CLOSE].callback do
              self.class.queue.unsubscribe if subscribed
            end
            throw :async
          else
            do_get_commands
          end
        end

        protected
        def do_get_commands
          queue_content = self.class.queue.clear
          [200, {'Content-Type' => "application/json"}, queue_content.to_json]
        end
      end
    end
  end
end
