var sys = require('sys'),
    express = require('express'),
    fs = require('fs'),
    path = require('path');

get("/*", function() {
  var self = this;
  filePath = path.join(JsTestServer.Server.rootPath, this.url.pathname)
  fs.stat(filePath, function(err, stats) {
    if (stats.isDirectory()) {
      JsTestServer.Server.Views.Directory(filePath, function(html) {
        self.respond(200, html)
      })
    } else if (stats.isFile()) {
      fs.readFile(
        filePath,
        function(err, data) {
          self.respond(200, data)
        }
      )
    } else {
      this.pass()
    }
  });
});