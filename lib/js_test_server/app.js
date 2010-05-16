require("../js_test_server");
var sys = require("sys"),
    trollopjs = require("trollopjs"),
    path = require("path");

var opts = trollopjs.options(function() {
  this.opt(
    'framework-name',
    "The name of the test framework you want to use. e.g. --framework-name=jasmine"
  );
  this.opt(
      'framework-path',
    "The name of the test framework you want to use. e.g. --framework-path=./specs/jasmine_core"
  );
  this.opt(
    'spec-path',
    "The path to the spec files. e.g. --spec-path=./specs",
    {dflt: "./spec/javascripts"}
  );
  this.opt(
    'root-path',
    "The root path of the server. e.g. --root-path=./public",
    {dflt: "./public"}
  );
  this.opt('port', "The server port", {dflt: 3000});
});

JsTestServer.Server.frameworkName = opts['framework-name']
JsTestServer.Server.frameworkPath = opts['framework-path']
JsTestServer.Server.rootPath = path.normalize(opts['root-path'])
JsTestServer.Server.specPath = path.normalize(opts['spec-path'])
JsTestServer.Server.port = opts['port']

Express.server.port = JsTestServer.Server.port
sys.puts("Starting JS Test Server on port " + JsTestServer.Server.port)
run()