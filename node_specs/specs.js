require.paths.push("./jasmine-node/lib");
var jasmine = require('jasmine');
var sys = require('sys');

process.mixin(global, jasmine);

jasmine.executeSpecsInFolder('./js_test_core', function(runner, log){
  process.exit(runner.results().failedCount);
}, true);
