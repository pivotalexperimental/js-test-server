var sys = require('sys'),
    http = require('http');

describe("/", function() {
  DescribeHelper.useServer(this);

  it("renders a welcome message", function() {
    var body;
    SpecHelper.performRequest("GET", "/", {"host": "localhost"}, function(_body) {
      body = _body;
    });
    waitsFor(10000, function() {
      sys.puts(body)
      return body;
    });
    expect(body).toMatch("Welcome to the Js Test Server. Click the following link")
  });
});
