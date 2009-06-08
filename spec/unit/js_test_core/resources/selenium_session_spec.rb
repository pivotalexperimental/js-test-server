require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe SeleniumSession do
      attr_reader :request, :driver, :session_id, :selenium_browser_start_command

      def self.before_with_selenium_browser_start_command(selenium_browser_start_command="selenium browser start command")
        before do
          @driver = FakeSeleniumDriver.new
          @session_id = FakeSeleniumDriver::SESSION_ID
          @selenium_browser_start_command = selenium_browser_start_command
          stub(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
            driver
          end
        end
      end

      after do
        SeleniumSession.send(:instances).clear
      end

      describe ".find" do
        attr_reader :selenium_session
        before_with_selenium_browser_start_command
        before do
          @selenium_session = SeleniumSession.new(:connection => connection, :selenium_browser_start_command => selenium_browser_start_command)
          stub(selenium_session).driver {driver}
          stub(driver).session_id {session_id}
          SeleniumSession.register(selenium_session)
        end
        
        context "when passed an id for which there is a corresponding selenium_session" do
          it "returns the selenium_session" do
            SeleniumSession.find(session_id).should == selenium_session
          end
        end

        context "when passed an id for which there is no corresponding selenium_session" do
          it "returns nil" do
            invalid_id = "666666666666666"
            SeleniumSession.find(invalid_id).should be_nil
          end
        end
      end

      describe "POST /selenium_sessions" do
        before_with_selenium_browser_start_command
        before do
          stub(Thread).start.yields
        end

        it "responds with a 200 and the session_id" do
          SeleniumSession.find(session_id).should be_nil
          response = post(SeleniumSession.path("/"), {:selenium_browser_start_command => selenium_browser_start_command})
          body = "session_id=#{session_id}"
          response.should be_http(
            200,
            {'Content-Length' => body.length.to_s},
            body
          )
        end

        it "starts the Selenium Driver, creates a SessionID cookie, and opens the spec page" do
          mock(driver).start
          stub(driver).session_id {session_id}
          mock(driver).create_cookie("session_id=#{session_id}")
          mock(driver).open("/")
          mock(driver).open("/specs")

          mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
            driver
          end
          response = post(SeleniumSession.path("/"), {:selenium_browser_start_command => selenium_browser_start_command})
        end

        describe "when a selenium_host parameter is passed into the request" do
          it "starts the Selenium Driver with the passed in selenium_host" do
            mock(Selenium::Client::Driver).new('another-machine', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
            response = post(SeleniumSession.path("/"), {
              :selenium_browser_start_command => selenium_browser_start_command,
              :selenium_host => "another-machine"
            })
          end
        end

        describe "when a selenium_host parameter is not passed into the request" do
          it "starts the Selenium Driver from localhost" do
            mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
            response = post(SeleniumSession.path("/"), {
              :selenium_browser_start_command => selenium_browser_start_command,
              :selenium_host => ""
            })
          end
        end

        describe "when a selenium_port parameter is passed into the request" do
          it "starts the Selenium Driver with the passed in selenium_port" do
            mock(Selenium::Client::Driver).new('localhost', 4000, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
            response = post(SeleniumSession.path("/"), {
              :selenium_browser_start_command => selenium_browser_start_command,
              :selenium_port => "4000"
            })
          end
        end

        describe "when a selenium_port parameter is not passed into the request" do
          it "starts the Selenium Driver from localhost" do
            mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
            response = post(SeleniumSession.path("/"), {
              :selenium_browser_start_command => selenium_browser_start_command,
              :selenium_port => ""
            })
          end
        end

        describe "when a spec_url is passed into the request" do
          it "runs Selenium with the passed in host and part to run the specified spec session in Firefox" do
            mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://another-host:8080') do
              driver
            end
            mock(driver).start
            stub(driver).create_cookie
            mock(driver).open("/")
            mock(driver).open("/specs/subdir")
            mock(driver).session_id {session_id}.at_least(1)

            response = post(SeleniumSession.path("/"), {
              :selenium_browser_start_command => selenium_browser_start_command,
              :spec_url => "http://another-host:8080/specs/subdir"
            })
          end
        end

        describe "when a spec_url is not passed into the request" do
          before do
            mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
          end

          it "uses Selenium to run the entire spec session in Firefox" do
            mock(driver).start
            stub(driver).create_cookie
            mock(driver).open("/")
            mock(driver).open("/specs")
            mock(driver).session_id {session_id}.at_least(1)

            response = post(SeleniumSession.path("/"), {
              :selenium_browser_start_command => selenium_browser_start_command,
              :spec_url => ""
            })
          end
        end
      end

      describe "POST /selenium_sessions/firefox" do
        before_with_selenium_browser_start_command "*firefox"

        it "creates a selenium_session whose #driver started with '*firefox'" do
          SeleniumSession.find(session_id).should be_nil
          response = post(SeleniumSession.path("/firefox"))
          body = "session_id=#{session_id}"
          response.should be_http(
            200,
            {'Content-Length' => body.length.to_s},
            body
          )

          selenium_session = SeleniumSession.find(session_id)
          selenium_session.class.should == SeleniumSession
          selenium_session.driver.should == driver
        end
      end

      describe "POST /selenium_sessions/iexplore" do
        before_with_selenium_browser_start_command "*iexplore"

        it "creates a selenium_session whose #driver started with '*iexplore'" do
          SeleniumSession.find(session_id).should be_nil
          response = post(SeleniumSession.path("/iexplore"))
          body = "session_id=#{session_id}"
          response.should be_http(
            200,
            {'Content-Length' => body.length.to_s},
            body
          )

          selenium_session = SeleniumSession.find(session_id)
          selenium_session.class.should == SeleniumSession
          selenium_session.driver.should == driver
        end
      end

      describe "#running?" do
        before_with_selenium_browser_start_command
        context "when the driver#session_started? is true" do
          it "returns true" do
            response = post(SeleniumSession.path("/"), {:selenium_browser_start_command => selenium_browser_start_command})
            response.should be_http(
              200,
              {},
              ""
            )

            selenium_session = Resources::SeleniumSession.find(session_id)
            selenium_session.driver.session_started?.should be_true
            selenium_session.should be_running
          end
        end

        context "when the driver#session_started? is false" do
          it "returns false" do
            response = post(SeleniumSession.path("/"), {:selenium_browser_start_command => selenium_browser_start_command})
            response.should be_http(
              200,
              {},
              ""
            )

            selenium_session = Resources::SeleniumSession.find(session_id)
            selenium_session.driver.stop
            selenium_session.driver.session_started?.should be_false
            selenium_session.should_not be_running
          end
        end
      end

      describe "#finalize" do
        attr_reader :selenium_session
        before_with_selenium_browser_start_command
        before do
          response = post(SeleniumSession.path("/"), {:selenium_browser_start_command => selenium_browser_start_command})
          response.status.should == 200
          @selenium_session = Resources::SeleniumSession.find(session_id)
          mock.proxy(driver).stop
        end

        it "kills the browser and stores the #session_run_result" do
          session_run_result = "The session run result"
          selenium_session.finalize(session_run_result)
          selenium_session.session_run_result.should == session_run_result
        end

        it "sets #session_run_result" do
          selenium_session.finalize("the result")
          selenium_session.session_run_result.should == "the result"
        end

        context "when passed an empty string" do
          it "causes #successful? to be true" do
            selenium_session.finalize("")
            selenium_session.should be_successful
            selenium_session.should_not be_failed
          end
        end

        context "when passed a non-empty string" do
          it "causes #successful? to be false" do
            selenium_session.finalize("A bunch of error stuff")
            selenium_session.should_not be_successful
            selenium_session.should be_failed
          end
        end
      end
    end
  end
end