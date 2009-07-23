require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestServer::Server::Resources
  describe FrameworkFile do
    describe "Files" do
      describe "GET /framework/JsTestServer.js" do
        it "renders the JsTestServer.js file, which lives in the core framework directory" do
          absolute_path = "#{framework_path}/example_framework.js"

          response = get(FrameworkFile.path("example_framework.js"))
          response.should be_http(
            200,
            {
              "Content-Type" => "text/javascript",
              "Last-Modified" => ::File.mtime(absolute_path).rfc822
            },
            ::File.read(absolute_path)
          )
        end
      end
    end

    describe "Directories" do
      macro "returns a page with the files in the root core directory" do |relative_path|
        it "returns a page with the files in the root core directory" do
          response = get(FrameworkFile.path(relative_path))
          response.should be_http(
            200,
            {},
            ""
          )
          doc = Nokogiri::HTML(response.body)
          links = doc.search("a").map {|script| script["href"]}
          links.should include("/framework/example_framework.js")
          links.should include("/framework/example_framework.css")
          links.should include("/framework/subdir")
        end
      end
      describe "GET /framework" do
        send("returns a page with the files in the root core directory", "")
      end
      describe "GET /framework/" do
        send("returns a page with the files in the root core directory", "/")
      end

      describe "GET /framework/subdir" do
        it "returns a page with the files in the directory" do
          response = get(FrameworkFile.path("subdir"))
          response.should be_http(
            200,
            {},
            %r(<a href="/framework/subdir/SubDirFile.js">SubDirFile.js</a>)
          )
        end
      end
    end
  end
end
