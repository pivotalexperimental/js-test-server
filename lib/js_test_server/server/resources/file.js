var sys = require('sys'),
    express = require('express'),
    fs = require('fs'),
    path = require('path');

get("/*", function() {
  var self = this;
  filePath = path.join(JsTestServer.Server.rootPath, this.url.pathname)
  fs.stat(filePath, function(err, stats) {
    if (stats.isDirectory()) {
      global.JsTestServer.Views.Directory(filePath, function(html) {
        sys.puts(__filename + ":14")
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