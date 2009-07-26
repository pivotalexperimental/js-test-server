(function() {
  JsTestServer.RemoteControl = function() {
  }

  JsTestServer.RemoteControl.prototype.start = function() {
    this.poll();
  };

  JsTestServer.RemoteControl.prototype.poll = function() {
    var self = this;
    JsTestServer.xhrGet("/remote_control", function(request) {
      if(request.status == 200) {
        eval(request.responseText);
        self.poll();
      };
    });
  };
})();