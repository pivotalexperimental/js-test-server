var sys = require('sys'),
    http = require('http')

describe("GET /specs/passing_spec.js - a file", function() {
  it("renders project js files", function() {
    SpecHelper.performRequest("GET", "/specs/passing_spec", {"host": "localhost"}, function(response) {
      require('sys').puts(response.body)
      //    expect(Y.one("script[@src='/javascripts/test_file_1.js']")).toNotBeNull()
      //    expect(Y.one("script[@src='/javascripts/test_file_2.js']")).toNotBeNull()
    });
  })

  it("renders a file the given path appended to --root-path", function() {
//    SpecHelper.performRequest("GET", "/javascripts/foo.js", {"host": "localhost"}, function(response) {
//      expect(response.body).toMatch("Foo")
//    });
  });
});
