JsTestServer.JasmineDriver = {};

JsTestServer.JasmineDriver.init = function() {
  JsTestServer.JasmineDriver.instance = new JsTestServer.JasmineDriver.Instance();
  JsTestServer.JasmineDriver.instance.init();
  JsTestServer.JasmineDriver.instance.startJasmine();
};

JsTestServer.JasmineDriver.Instance = function() {
};

(function(Instance) {
  var jsTestServerReporter;

  Instance.prototype.init = function() {
    this.defineStatusMethod();
  };

  Instance.prototype.defineStatusMethod = function() {
    JsTestServer.status = function() {
      var runnerState;
      var jasmineEnv = jasmine.getEnv();
      jasmineEnv.reporter.log("jsTestServerReporter.finished: " + jsTestServerReporter.finished)

      return JsTestServer.JSON.stringify({
        "runner_state": jsTestServerReporter.runnerState,
        "console": jsTestServerReporter.console
      });
    };
  };

  Instance.prototype.startJasmine = function() {
    var jasmineEnv = jasmine.getEnv();
    jsTestServerReporter = new JsTestServer.JasmineDriver.Reporter();
    jasmineEnv.addReporter(jsTestServerReporter);
    jasmineEnv.addReporter(new jasmine.JsApiReporter());
    jasmine.TrivialReporter.prototype.log = function() {
      if (window.console && window.console.log) window.console.log.apply(window.console, arguments);
    };
    jasmineEnv.addReporter(new jasmine.TrivialReporter());

    window.onload = function() {
      jasmineEnv.execute();
    }
  };

  JsTestServer.JasmineDriver.Reporter = function() {
    this.console = "";
    this.finished = false;
    this.runnerState = "running";
  };
  JsTestServer.JasmineDriver.Reporter.prototype.log = function(str) {
    this.console += (str + "\n");
  };
  JsTestServer.JasmineDriver.Reporter.prototype.reportRunnerResults = function(runner) {
    this.finished = true;
    if (runner.results().failedCount == 0) {
      this.runnerState = "passed";
    } else {
      this.runnerState = "failed";
    }
  }
})(JsTestServer.JasmineDriver.Instance);
