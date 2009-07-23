JsTestServer.JasmineDriver = {};

JsTestServer.JasmineDriver.init = function() {
  JsTestServer.JasmineDriver.instance = new JsTestServer.JasmineDriver.Instance();
  JsTestServer.JasmineDriver.instance.start();
};

JsTestServer.JasmineDriver.Instance = function() {
};

(function(Instance) {
  var jsTestServerConsole = "";
  var reporter;

  Instance.prototype.start = function() {
    this.addJasmineReporter();
    this.defineStatusMethod();
    this.startJasmine();
  };

  Instance.prototype.addJasmineReporter = function() {
    reporter = new JsTestServer.JasmineDriver.Reporter();
    jasmine.getEnv().addReporter(reporter);
  };

  Instance.prototype.defineStatusMethod = function() {
    JsTestServer.status = function() {
      var runnerState;
      if(jasmine.getEnv().currentRunner.finished) {
        if(jasmine.getEnv().currentRunner.getResults().failedCount == 0) {
          runnerState = "passed";
        } else {
          runnerState = "failed";
        }
      } else {
        runnerState = "running";
      }

      return JsTestServer.JSON.stringify({
        "runner_state": runnerState,
        "console": jsTestServerConsole
      });
    };
  };

  Instance.prototype.startJasmine = function() {
    var jasmineEnv = jasmine.getEnv();
    var jsApiReporter = new jasmine.JsApiReporter();
    jasmineEnv.addReporter(jsApiReporter);
    jasmineEnv.addReporter(new jasmine.TrivialReporter());
    window.onload = function() {
      jasmineEnv.execute();
    };
  };

  JsTestServer.JasmineDriver.Reporter = function() {
  };
  JsTestServer.JasmineDriver.Reporter.prototype.log = function(str) {
    jsTestServerConsole += str;
    jsTestServerConsole += "\n";
  };
})(JsTestServer.JasmineDriver.Instance);
