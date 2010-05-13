class JsTestServer::Server::Representations::NotFound < JsTestServer::Server::Representations::Page
  needs :message
  attr_reader :message
  protected

  def body_content
    h1 message
  end

  def title_text
    message
  end
end
