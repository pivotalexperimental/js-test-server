var sys = require('sys'),
    http = require('http');

describe("GET /framework/foo.js - a file", function() {
  it("renders a file the given path appended to --framework-path", function() {
    SpecHelper.performRequest("GET", "/framework/example_framework.js", {"host": "localhost"}, function(response) {
      expect(response.body).toMatch("ExampleFramework")
    });
  });
});

describe("GET /framework/subdir - a directory", function() {
  it("renders the list of files in the directory with the give path appended to --framework-path", function() {
    SpecHelper.performRequest("GET", "/framework/subdir", {"host": "localhost"}, function(response) {
      expect(response.body).toMatch("/framework/subdir/SubDirFile.js")
    });
  });
});

describe("GET /framework/i-dont-exist - not a file", function() {
  it("responds with a 404", function() {
    SpecHelper.performRequest("GET", "/framework/i-dont-exist", {"host": "localhost"}, function(response) {
      expect(response.statusCode).toEqual(404)
    });
  });
});
