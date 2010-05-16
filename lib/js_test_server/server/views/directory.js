var sys = require("sys"),
  fs = require('fs'),
  childProcess = require("child_process"),
  xmlbuilder = require("xmlbuilder"),
  path = require("path");

JsTestServer.Views.Directory = function(directoryPath, callback) {
  var self = this;

  var files = []
  var directoryPathOnServer = path.normalize(directoryPath).replace(JsTestServer.Server.rootPath, "")
  var ls = childProcess.spawn("ls", ["-1", directoryPath])
  ls.stdout.addListener("data", function(data) {
    files.push.apply(files, data.toString().split("\n"))
  });
  ls.addListener("exit", function(code, signal) {
    callback(
      (function() {
        var b = new XmlBuilder({binding: self})
        with(b) {
          ul(function() {
            _(files).each(function(file) {
              li(function() {
                a(file.toString(), {href: directoryPathOnServer + "/" + file})              
              })
            })
          })
        }
        return b.toString()
      })()
    )
  })
};
