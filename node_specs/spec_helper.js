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
  startServer: function() {
    var proc = childProcess.spawn("node", [this.serverRoot(), "--port=" + SpecHelper.serverPort()]);
    var serverStarted = false;
    var dataListener = function(data) {
      if (/Express started at /.exec(data)) {
        serverStarted = true;
      }
    };
    proc.stdout.addListener("data", dataListener);
    process.addListener('SIGINT', function() {
      sys.puts("in SIGINT")
      this.stopServer(proc)
    })

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