class Rack::MockSession
  attr_writer :last_response

  def last_response
    @last_response
  end
end

class Rack::Test::Session
  class << self
    def http_action_with_async_catch(method_name)
      alias_method "#{method_name}_without_async_catch", method_name
      class_eval((<<-RUBY), __FILE__, __LINE__)
      def #{method_name}_with_async_catch(*args, &block)
        catch(:async) {return #{method_name}_without_async_catch(*args, &block)}
        nil
      end
      RUBY
      alias_method method_name, "#{method_name}_with_async_catch"
    end
  end

  def_delegators :@rack_mock_session, :last_response=

  http_action_with_async_catch :get
  http_action_with_async_catch :put
  http_action_with_async_catch :post
  http_action_with_async_catch :delete
end

