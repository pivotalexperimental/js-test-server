var sys = require('sys'),
    express = require('express');

exports.bind = function() {
  get("/", function() {
    return "<html><head></head><body>Welcome to the Js Test Server. Click the following link to run your <a href=/specs>spec suite</a>.</body></html>";
  })
}