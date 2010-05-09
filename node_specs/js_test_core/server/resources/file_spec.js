var sys = require('sys'),
    http = require('http');

describe("GET /javascripts/foo.js - a file", function() {
  DescribeHelper.useServer(this);

  it("renders a file from --root-path", function() {
    var body = "";
    SpecHelper.performRequest("GET", "/javascripts/foo.js?foo=bar", {"host": "localhost"}, function(_body) {
      body = _body;
    });
    waitsFor(10000, function() {
      return body && (
        expect(body).toMatch("Foo") || true
      )
    });
  });
});
