require("./server");
var sys = require("sys");

Express.server.port = process.env['JS_TEST_SERVER_PORT'] || 3000;
sys.puts("Starting JS Test Server on port " + Express.server.port)
run()
