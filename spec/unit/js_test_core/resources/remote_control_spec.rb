require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestServer::Server::Resources
  describe RemoteControl do
    attr_reader :browser_session, :command_line_session, :browser_async_callback
    before do
      @browser_session = rack_test_session("Browser Session")
      @command_line_session = rack_test_session("Command Line Session")

      @browser_async_callback = lambda do |commands_response|
        browser_session.last_response = Rack::MockResponse.new(*commands_response)
      end
    end

    describe "GET /remote_control/subscriber" do
      it "renders a page that polls the commands" do
        browser_session.get(RemoteControl.path("/subscriber"))
        browser_session.last_response.should be_http( 200, {}, "" )

        doc = Nokogiri::HTML(browser_session.last_response.body)
        doc.at("a[href='#{RemoteControl.path("commands")}']").should_not be_nil
      end
    end

    describe "POST /remote_control/commands" do
      attr_reader :command_response

      it "puts javascript to be executed to the queue and responds with the response from the browser" do
        client_creates_a_command
        browser_gets_commands_and_sends_response
        wait_for {command_response}
        command_response.should be_http(200, {}, "")
        #command_response.should be_http(200, {}, "response from browser")
      end

      def client_creates_a_command
        RemoteControl.queue.to_a.should be_empty
        request_thread = Thread.start do
          @command_response = command_line_session.post(RemoteControl.path("/commands"), :javascript => "alert('hello');")
        end

        wait_for { RemoteControl.queue.to_a.length == 1 }
      end

      def browser_gets_commands_and_sends_response
        browser_session.get( RemoteControl.path("/commands"), {}, {
          Thin::Request::ASYNC_CLOSE => FakeDeferrable.new,
          Thin::Request::ASYNC_CALLBACK => browser_async_callback
        })
        commands = JSON.parse(browser_session.last_response.body)
        commands.length.should == 1
        #post("commands/#{commands.first["id"]}/response", "response" => "response from browser")
      end
    end

    describe "GET /remote_control/commands" do
      context "when the queue is empty" do
        before do
          RemoteControl.queue.to_a.should be_empty
        end

        context "when Object::Thin is defined" do
          before do
            Object.const_defined?(:Thin).should be_true
          end

          it "waits until there is a message in the queue to return a response" do
            js = "alert('hello');"
            browser_session.get(RemoteControl.path("/commands"), {}, {
              Thin::Request::ASYNC_CLOSE => FakeDeferrable.new,
              Thin::Request::ASYNC_CALLBACK => browser_async_callback
            })
            browser_session.last_response.should be_nil

            command_line_session.post(RemoteControl.path("/commands"), {:javascript => js})

            browser_session.last_response.should be_http(
              200,
              {"Content-Type" => "application/json"},
              [{"javascript" => js}].to_json
            )
          end
        end

        context "when Object::Thin is not defined" do
          before do
            stub(Object).const_defined?(:Thin) {false}
          end

          it "renders an empty array" do
            browser_session.get(RemoteControl.path("/commands"))
            browser_session.last_response.should be_http(200, {"Content-Type" => "application/json"}, [].to_json)
          end
        end
      end

      context "when the queue is not empty" do
        attr_reader :js
        before do
          post(RemoteControl.path("/commands"), {:javascript => "alert('hello');"})
          @js = "alert('hello');"
          RemoteControl.queue.to_a.length.should == 1
          RemoteControl.queue.to_a.first["javascript"].should == js
        end

        it "renders an array of the unsent javascript commands in the queue and clears the queue" do
          browser_session.get(RemoteControl.path("/commands"), {}, {
            Thin::Request::ASYNC_CLOSE => FakeDeferrable.new,
            Thin::Request::ASYNC_CALLBACK => browser_async_callback
          })
          browser_session.last_response.should be_http(200, {"Content-Type" => "application/json"}, [{"javascript" => js}].to_json)
          RemoteControl.queue.to_a.should be_empty
        end
      end
    end
  end
end