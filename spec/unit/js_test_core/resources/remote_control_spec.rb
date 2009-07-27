require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestServer::Server::Resources
  describe RemoteControl do
    describe "GET /remote_control/subscriber" do
      it "renders a page that polls the commands" do
        response = get(RemoteControl.path("/subscriber"))
        response.should be_http( 200, {}, "" )

        doc = Nokogiri::HTML(response.body)
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
        RemoteControl.queue.should be_empty
        request_thread = Thread.start do
          @command_response = post(RemoteControl.path("/commands"), :javascript => "alert('hello');")
        end

        wait_for { RemoteControl.queue.size == 1 }
      end

      def browser_gets_commands_and_sends_response
        response = get(RemoteControl.path("/commands"))
        commands = JSON.parse(response.body)
        commands.length.should == 1
        post("commands/#{commands.first["id"]}/response", "response" => "response from browser")
      end
    end

    describe "GET /remote_control/commands" do
      context "when the queue is empty" do
        before do
          RemoteControl.queue.should be_empty
        end

        context "when Object::Thin is defined" do
          before do
            Object.const_defined?(:Thin).should be_true
          end

          it "throws to :async, and waits until there is a message in the queue to return a response" do
            js = "alert('hello');"
            rc = nil
            mock.proxy(RemoteControl).new.with_any_args do |rc|
              rc = rc
              mock(rc).throw(:async)
            end

            async_response = nil
            mock.strong(EM).add_timer(RemoteControl::POLL_STEP_PERIOD) do |timeout, blk|
              RemoteControl.queue << js
              rc.env[Thin::Request::ASYNC_CALLBACK] = lambda do |rack_response|
                async_response = rack_response
              end
              blk.call
            end

            get(RemoteControl.path("/commands"))
            async_response[0].should == 200
            async_response[1]["Content-Type"].should == "application/json"
            async_response[2].should == [js].to_json
          end
        end

        context "when Object::Thin is not defined" do
          before do
            stub(Object).const_defined?(:Thin) {false}
          end

          it "renders an empty array" do
            response = get(RemoteControl.path("/commands"))
            response.should be_http(200, {"Content-Type" => "application/json"}, [].to_json)
          end
        end
      end

      context "when the queue is not empty" do
        attr_reader :js
        before do
          post(RemoteControl.path("/commands"), :javascript => "alert('hello');")
          @js = "alert('hello');"
          RemoteControl.queue.length.should == 1
          RemoteControl.queue.first["javascript"].should == js
        end

        it "renders an array of the unsent javascript commands in the queue and clears the queue" do
          response = get(RemoteControl.path("/commands"))
          response.should be_http(200, {"Content-Type" => "application/json"}, [{"javascript" => js}].to_json)
          RemoteControl.queue.should be_empty
        end
      end
    end
  end
end