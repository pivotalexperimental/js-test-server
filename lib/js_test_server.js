var sys = require('sys'),
    path = path = require("path");
require.paths.unshift(
  path.join(path.dirname(__filename), "../vendor"),
  path.join(path.dirname(__filename), "../vendor/express/lib"),
  path.join(path.dirname(__filename), "../vendor/ext.js/lib"),
  path.join(path.dirname(__filename), "../vendor/trollopjs/lib"),
  path.join(path.dirname(__filename), "../vendor/xmlbuilder.js/lib"),
  path.join(path.dirname(__filename), "../vendor/underscore")
)

global.JsTestServer = {}
global.trace = function() {
  // Taken from (http://github.com/emwendelin/javascript-stacktrace)
  return (new Error()).stack.
                replace(/^.*?\n/, '').
                replace(/^.*?\n/, '').
                replace(/^.*?\n/, '').
                replace(/^[^\(]+?[\n$]/gm, '').
                replace(/^\s+at\s+/gm, '').
                replace(/^Object.<anonymous>\s*\(/gm, '{anonymous}()@').
                split("\n");
}
require("./js_test_server/server");
