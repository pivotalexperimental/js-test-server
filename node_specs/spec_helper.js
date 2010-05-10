var path = require("path"),
  sys = require("sys"),
  childProcess = require("child_process"),
  http = require('http');

var jsTestServerDir = path.join(path.dirname(__filename), "../lib");
require.paths.push(jsTestServerDir);

require.paths.unshift(
  path.join(path.dirname(__filename), "../lib"),
  path.join(path.dirname(__filename), "jasmine-node/lib")
  );
require("js_test_server");
require("underscore");

var jasmine = require('jasmine');
_(global).extend(jasmine);

var SpecHelper = {
  defaultPath: process.ARGV[1],
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

  startSpecs: function(specPath) {
    if (!specPath) {
      specPath = SpecHelper.defaultPath
    }
    sys.puts("startSpecs");
    var self = this
    sys.puts("Starting server");
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
    proc.stdout.addListener("data", function(data) {
      sys.puts(data);
      if (/Express started at/.exec(data)) {
        jasmine.executeSpecsInFolder(specPath, function(runner, log) {
          sys.puts("finished specs");
          self.stopServer(proc);
          process.exit(runner.results().failedCount);
        }, true)
      }
    });
    sys.puts("finished");
  },

  performRequest: function(method, path, params, callback) {
    var localhost = http.createClient(SpecHelper.serverPort(), "localhost");
    var request = localhost.request(method, path, params);
    var body = "", responseFinished = false;
    request.addListener('response', function (response) {
      response.addListener("data", function (chunk) {
        body += chunk;
      });
      response.addListener('end', function () {
        responseFinished = true
      });
    });
    request.end();
    waitsFor(10000, function() {
      return responseFinished && (callback(body) || true)
    });
  },

  stopServer: function(proc) {
    proc.removeAllListeners();
    proc.kill();
  }
}
global.SpecHelper = SpecHelper;

var DescribeHelper = {
}
global.DescribeHelper = DescribeHelper;

if ((new RegExp(".+_spec.js$")).exec(process.ARGV[1])) {
  SpecHelper.startSpecs();
}
