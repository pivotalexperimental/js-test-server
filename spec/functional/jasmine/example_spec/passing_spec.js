require("/javascripts/foo");

describe("A passing spec", function() {
  it("passes", function() {
    expect(Foo.value).toEqual(true);
  });
});
