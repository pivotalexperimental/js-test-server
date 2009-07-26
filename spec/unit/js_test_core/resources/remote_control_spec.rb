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
        response = get(RemoteControl.path("/messages")) 
        response.should be_http(200, {"Content-Type" => "application/json"}, [].to_json)
      end
    end
  end
end