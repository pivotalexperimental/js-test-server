var path = require("path");
var libDir = path.join(path.dirname(__filename), "server/express/lib");
require.paths.unshift(libDir)
var kiwi = require('kiwi'),
    sys = require('sys');

var express = require('express')

require("./server/routes");
require("./server/resources");