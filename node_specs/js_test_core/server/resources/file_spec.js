var sys = require('sys'),
    http = require('http');

describe("GET /javascripts/foo.js - a file", function() {
  it("renders a file the given path appended to --root-path", function() {
    SpecHelper.performRequest("GET", "/javascripts/foo.js", {"host": "localhost"}, function(response) {
      expect(response.body).toMatch("Foo")
    });
  });
});

describe("GET /javascripts - a directory", function() {
  it("renders the list of files in the directory with the give path appended to --root-path", function() {
    SpecHelper.performRequest("GET", "/javascripts", {"host": "localhost"}, function(response) {
      expect(response.body).toMatch("/javascripts/foo.js")
      expect(response.body).toMatch("/javascripts/large_file.js")
      expect(response.body).toMatch("/javascripts/subdir")
    });
  });
});

describe("GET /i-dont-exist - not a file", function() {
  it("responds with a 404", function() {
    SpecHelper.performRequest("GET", "/i-dont-exist", {"host": "localhost"}, function(response) {
      expect(response.statusCode).toEqual(404)
    });
  });
});
