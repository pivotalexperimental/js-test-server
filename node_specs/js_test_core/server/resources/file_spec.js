var sys = require('sys'),
    http = require('http');

describe("/", function() {
  DescribeHelper.useServer(this);

  it("renders a file from --root-path", function() {
    var body = "";
    SpecHelper.performRequest("GET", "/javascripts/foo.js", {"host": "localhost"}, function(_body) {
      body = _body;
    });
    waitsFor(10000, function() {
      sys.puts(expect(body).toMatch("Foo"))
      return(body && expect(body).toMatch("Foo"));
    });
  });
});
