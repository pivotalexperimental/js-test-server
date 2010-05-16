var sys = require('sys'),
    fs = require('fs')

JsTestServer.Server.Resources.FileDispatch = function(request, filePath) {
  fs.stat(filePath, function(err, stats) {
    if (stats && stats.isDirectory()) {
      global.JsTestServer.Views.Directory(filePath, request.url.pathname, function(html) {
        request.respond(200, html)
      })
    } else if (stats && stats.isFile()) {
      fs.readFile(
        filePath,
        function(err, data) {
          request.respond(200, data)
        }
      )
    } else {
      request.pass()
    }
  })
}