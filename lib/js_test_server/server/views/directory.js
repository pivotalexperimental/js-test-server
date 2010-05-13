var sys = require("sys"),
  fs = require('fs'),
  childProcess = require("child_process"),
  xmlbuilder = require("xmlbuilder");

JsTestServer.Views.Directory = function(directoryPath, callback) {
  var self = this;

  var ls = childProcess.spawn("ls", ["-1"])
  var files = []
  ls.stdout.addListener("data", function(data) {
    sys.puts(__filename + ":12")
    files.push(data.split("\n"))
    sys.puts(JSON.stringify(files));
  });
  ls.addListener("exit", function(code, signal) {
    sys.puts(__filename + ":16")
    callback(
      (function() {
        var b = new XmlBuilder({binding: self})
        b.ul(function() {
          _(files).each(function(file) {
            b.li(file)
          })
        })
      })()
    )
  })
};
