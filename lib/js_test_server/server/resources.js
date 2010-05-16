var sys = require('sys'),
    express = require('express');
require("./resources/web_root");
require("./resources/file");
get("/*", function() {
  this.respond(404, "No such file or directory")
});
