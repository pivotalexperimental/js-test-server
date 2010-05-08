var sys = require('sys'),
    express = require('express'),
    fs = require('fs');

get("*", function() {
//  fs.stats.isDirectory();
  return "<html><head></head><body>Welcome to the Js Test Server. Click the following link to run your <a href=/specs>spec suite</a>.</body></html>";
});