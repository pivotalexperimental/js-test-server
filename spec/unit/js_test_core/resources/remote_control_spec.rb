require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestServer::Server::Resources
  describe RemoteControl do
    describe "GET /remote_control/subscriber" do
      it "renders a page that polls the messages" do
        response = get(RemoteControl.path("/subscriber"))
        response.should be_http( 200, {}, "" )

        doc = Nokogiri::HTML(response.body)
        doc.at("a[href='#{RemoteControl.path("messages")}']").should_not be_nil
      end
    end

    describe "POST /remote_control/broadcasts" do
      it "puts javascript to be executed to the queue" do
        RemoteControl.queue.should be_empty
        response = post(RemoteControl.path("/broadcasts"), :javascript => "alert('hello');")

        RemoteControl.queue.should == ["alert('hello');"]
        response.should be_http(200, {"Content-Type" => "application/json"}, RemoteControl.queue.to_json)
      end
    end

    describe "GET /remote_control/messages" do
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

            get(RemoteControl.path("/messages"))
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
            response = get(RemoteControl.path("/messages"))
            response.should be_http(200, {"Content-Type" => "application/json"}, [].to_json)
          end
        end
      end
      
      context "when the queue is not empty" do
        attr_reader :js
        before do
          post(RemoteControl.path("/broadcasts"), :javascript => "alert('hello');")
          @js = "alert('hello');"
          RemoteControl.queue.should == [js]
        end

        it "renders an array of the unsent javascript messages in the queue and clears the queue" do
          response = get(RemoteControl.path("/messages"))
          response.should be_http(200, {"Content-Type" => "application/json"}, [js].to_json)
          RemoteControl.queue.should be_empty
        end
      end
    end
  end
end