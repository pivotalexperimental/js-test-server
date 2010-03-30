var sys = require('sys'),
  http = require('http');

describe("/", function() {
  var proc, dataListener;
  beforeEach(function() {
    process.env['JS_TEST_SERVER_PORT'] = 3000;

    var serverStarted = false;
    proc = SpecHelper.startServer();
    dataListener = function(data) {
      sys.puts("dataListener")
      if (/Express started at /.exec(data)) {
        serverStarted = true;
      }
    };
    proc.stdout.addListener("data", dataListener);

    waitsFor(10000, function() {
      return serverStarted;
    });
  });

  afterEach(function() {
    for(var m in proc) {
      sys.puts(m);
    }
    proc.removeAllListeners();
    proc.kill();
  });

  it("renders a welcome message", function() {
    var localhost = http.createClient(process.env['JS_TEST_SERVER_PORT'], "localhost");
    var request = localhost.request("GET", "/", {"host": "localhost"});
    var body = "";
    request.addListener('response', function (response) {
      sys.puts("response")
      response.addListener("data", function (chunk) {
        sys.puts("data")
        body += chunk;
      });
    });
    request.close();
    waitsFor(10000, function() {
      return body.indexOf("Welcome to the Js Test Server. Click the following link") > -1
    });
  });
});
