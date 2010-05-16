var sys = require('sys'),
    express = require('express')

exports.bind = function() {
  var notFoundResponse = function() {
    this.respond(404, "No such file or directory")
  }
  get("/*", notFoundResponse);
  post("/*", notFoundResponse);
  put("/*", notFoundResponse);
  del("/*", notFoundResponse);
}
