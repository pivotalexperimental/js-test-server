require("/javascripts/foo");

describe("A failing spec", function() {
  it("fails", function() {
    expect(Foo.value).toEqual(false);
  });
});
