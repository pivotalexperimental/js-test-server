var path = require("path"),
  sys = require("sys"),
  childProcess = require("child_process"),
  http = require('http');
var jsTestServerDir = path.join(path.dirname(__filename), "../lib");
require.paths.push(jsTestServerDir);

require("js_test_server");

var SpecHelper = {
  projectRoot: function() {
    return path.join(__dirname, "..");
  },
  libRoot: function() {
    return path.join(this.projectRoot(), "lib")
  },
  serverRoot: function() {
    return path.join(this.libRoot(), "js_test_server/app.js")
  },
  startServer: function() {
    var proc = childProcess.spawn("node", [this.serverRoot()]);
    var dataListener = function(data) {
      if (/Express started at /.exec(data)) {
        serverStarted = true;
      }
    };
    proc.stdout.addListener("data", dataListener);

    waitsFor(10000, function() {
      try {
        return serverStarted &&
          http.createClient(
            process.env['JS_TEST_SERVER_PORT'], "localhost"
          ).request("GET", "/", {"host": "localhost"});
      } catch(e) {
        return false;
      }
    });
    return proc;
  }
}
global.SpecHelper = SpecHelper;

var DescribeHelper = {
  useServer: function(describe) {
    var proc;
    describe.beforeEach(function() {
      process.env['JS_TEST_SERVER_PORT'] = 3000;

      var serverStarted = false;
      proc = SpecHelper.startServer();
    });

    describe.afterEach(function() {
      proc.removeAllListeners();
      proc.kill();
    });
  }
}
global.DescribeHelper = DescribeHelper;