require("./spec_helper");
var sys = require("sys")
var jasmine = require('jasmine');

SpecHelper.startSpecs(process.ARGV[2] || (__dirname + '/js_test_core'));
