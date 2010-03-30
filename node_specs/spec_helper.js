var path = require("path"),
  sys = require("sys"),
  childProcess = require("child_process");
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
    return childProcess.spawn("node", [this.serverRoot()]);
  }
}
global.SpecHelper = SpecHelper;