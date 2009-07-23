class JsTestServer::Server::Representations::NotFound < JsTestServer::Server::Representations::Page
  needs :message
  protected

  def body_content
    h1 message
  end

  def title_text
    message
  end
end
