var sys = require('sys'),
    http = require('http');

describe("GET /javascripts/foo.js - a file", function() {
  it("renders a file the given path appended to --root-path", function() {
    SpecHelper.performRequest("GET", "/javascripts/foo.js", {"host": "localhost"}, function(body) {
      sys.puts(body);
      expect(body).toMatch("Foo")
    });
  });
});

describe("GET /javascripts - a directory", function() {
  it("renders the list of files in the directory with the give path appended to --root-path", function() {
    SpecHelper.performRequest("GET", "/javascripts", {"host": "localhost"}, function(body) {
      expect(body).toMatch("/javascripts/foo.js")
      expect(body).toMatch("/javascripts/large_file.js")
      expect(body).toMatch("/javascripts/subdir")
    });
  });
});