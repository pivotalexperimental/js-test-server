var sys = require('sys'),
    path = require("path");

require.paths.unshift(
  path.join(path.dirname(__filename), "../lib"),
  path.join(path.dirname(__filename), "jasmine-node/lib")
);
require("js_test_server");
require("underscore");
var jasmine = require('jasmine');

_(global).extend(jasmine);
require("./spec_helper");

jasmine.executeSpecsInFolder(__dirname + '/js_test_core', function(runner, log){
  process.exit(runner.results().failedCount);
}, true);
