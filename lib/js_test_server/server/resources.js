var sys = require('sys'),
    express = require('express');

JsTestServer.Server.Resources = {}

require("./resources/file_dispatch")

require("./resources/web_root").bind()
require("./resources/file").bind()
require("./resources/framework_file").bind()
get("/*", function() {
  this.respond(404, "No such file or directory")
});
