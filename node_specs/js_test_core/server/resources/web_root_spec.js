describe("/", function() {
  it("renders a welcome message", function() {
    SpecHelper.performRequest("GET", "/", {"host": "localhost"}, function(body) {
      expect(body).toMatch("Welcome to the Js Test Server. Click the following link")
    });
  });
});
