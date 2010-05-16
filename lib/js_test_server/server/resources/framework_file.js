var sys = require('sys'),
    express = require('express'),
    path = require('path');

exports.bind = function() {
  get("/framework/*", function() {
    JsTestServer.Server.Resources.FileDispatch(
      this,
      path.join(
        JsTestServer.Server.frameworkPath,
        this.url.pathname.replace(/\/framework\//, "/")
      )
    )
  });
}
