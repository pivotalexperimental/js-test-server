require("../js_test_server");
var sys = require("sys"),
    trollopjs = require("trollopjs");

var opts = trollopjs.options(function() {
  this.opt(
    'framework_name',
    "The name of the test framework you want to use. e.g. --framework-name=jasmine"
  );
  this.opt(
    'framework_path',
    "The name of the test framework you want to use. e.g. --framework-path=./specs/jasmine_core"
  );
  this.opt(
    'spec_path',
    "The path to the spec files. e.g. --spec-path=./specs",
    {dflt: "./spec/javascripts"}
  );
  this.opt(
    'root_path',
    "The root path of the server. e.g. --root-path=./public",
    {dflt: "./public"}
  );
  this.opt('port', "The server port", {dflt: 3000});
});

sys.puts(opts.port)
Express.server.port = opts.port
sys.puts("Starting JS Test Server on port " + opts.port)
run()
