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
  serverPort: function() {
    return 3000
  },
  specPath: function() {
    return path.join(__dirname, "../spec/example_spec")
  },
  rootPath: function() {
    return path.join(__dirname, "../spec/example_root")
  },
  frameworkPath: function() {
    return path.join(__dirname, "jasmine-node/lib/jasmine/jasmine-0.10.1.js")
  },
  frameworkName: function() {
    return "jasmine"
  },
  performRequest: function(method, path, params, callback) {
    var localhost = http.createClient(SpecHelper.serverPort(), "localhost");
    var request = localhost.request("GET", "/", {"host": "localhost"});
    var body = "";
    request.addListener('response', function (response) {
      response.addListener("data", function (chunk) {
        body += chunk;
      });
      response.addListener('end', function () {
        callback(body);
      });
    });
    request.end();
  },

  startServer: function() {
    var proc = childProcess.spawn(
      "node", [
        this.serverRoot(),
        "--port", SpecHelper.serverPort(),
        "--spec-path", SpecHelper.specPath(),
        "--root-path", SpecHelper.rootPath(),
        "--framework-path", SpecHelper.frameworkPath(),
        "--framework-name", SpecHelper.frameworkName()
    ]);
    var serverStarted = false;
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
            SpecHelper.serverPort(), "localhost"
          ).request("GET", "/", {"host": "localhost"});
      } catch(e) {
        return false;
      }
    });
    return proc;
  },

  stopServer: function(proc) {
    proc.removeAllListeners();
    proc.kill();
  }
}
global.SpecHelper = SpecHelper;

var DescribeHelper = {
  useServer: function(describe) {
    var proc;
    describe.beforeEach(function() {
      var serverStarted = false;
      proc = SpecHelper.startServer();
    });

    describe.afterEach(function() {
      SpecHelper.stopServer(proc);
    });
  }
}
global.DescribeHelper = DescribeHelper;