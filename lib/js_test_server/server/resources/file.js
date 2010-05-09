var sys = require('sys'),
    express = require('express'),
    fs = require('fs'),
    path = require('path');

get("/*", function() {
  fs.readFile(
    path.join(JsTestServer.Server.rootPath, this.url.pathname),
    function(err, data) {
      this.respond(200, data)
    }.bind(this)
  )
});