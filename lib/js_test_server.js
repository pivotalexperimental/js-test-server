var sys = require('sys'),
    path = path = require("path");
require.paths.unshift(
  path.join(path.dirname(__filename), "../vendor"),
  path.join(path.dirname(__filename), "../vendor/express/lib"),
  path.join(path.dirname(__filename), "../vendor/ext.js/lib"),
  path.join(path.dirname(__filename), "../vendor/trollopjs/lib"),
  path.join(path.dirname(__filename), "../vendor/underscore")
)
require("./js_test_server/server");