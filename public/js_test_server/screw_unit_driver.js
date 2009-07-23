(function($) {
  var jsTestServerStatus = {"runner_state": "running", "console": ""};

  JsTestServer.status = function() {
    return JsTestServer.JSON.stringify(jsTestServerStatus);
  };

  $(Screw).bind('after', function() {
    var error_text = $(".error").map(function(_i, error_element) {
      var element = $(error_element);

      var parent_descriptions = element.parents("li.describe");
      var parent_description_text = [];

      for(var i=parent_descriptions.length-1; i >= 0; i--) {
        parent_description_text.push($(parent_descriptions[i]).find("h1").text());
      }

      var it_text = element.parents("li.it").find("h2").text();

      return parent_description_text.join(" ") + " " + it_text + ": " + element.text();
    }).get().join("\\n");

    jsTestServerStatus["console"] = error_text;
    if(error_text) {
      jsTestServerStatus["runner_state"] = "failed";
    } else {
      jsTestServerStatus["runner_state"] = "passed";
    }
  });
})(jQuery);