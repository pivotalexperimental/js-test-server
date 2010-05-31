var sys = require('sys'),
    express = require('express');

JsTestServer.Server.Resources = {}

require("./resources/file_dispatch")

require("./resources/web_root").bind()
require("./resources/file").bind()
require("./resources/framework_file").bind()
require("./resources/spec_file").bind()
require("./resources/not_found").bind()
