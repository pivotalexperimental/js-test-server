var sys = require('sys'),
    http = require('http');

describe("/", function() {
  DescribeHelper.useServer(this);

  it("renders a welcome message", function() {
    var localhost = http.createClient(SpecHelper.serverPort(), "localhost");
    var request = localhost.request("GET", "/", {"host": "localhost"});
    var body = "";
    request.addListener('response', function (response) {
      response.addListener("data", function (chunk) {
        body += chunk;
      });
    });
    request.end();
    waitsFor(10000, function() {
      return body.indexOf("Welcome to the Js Test Server. Click the following link") > -1
    });
  });
});
