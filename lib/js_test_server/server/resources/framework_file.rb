class JsTestServer::Server::Resources::FrameworkFile < JsTestServer::Server::Resources::File
  map "/framework"

  get "/?" do
    do_get
  end

  get "*" do
    do_get
  end

  def absolute_path
    @absolute_path ||= ::File.expand_path("#{framework_path}#{relative_path.gsub(%r{^/framework}, "")}")
  end
end
