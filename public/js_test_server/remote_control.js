(function() {
  JsTestServer.RemoteControl = function() {
  };

  JsTestServer.RemoteControl.start = function() {
    var instance = new JsTestServer.RemoteControl();
    instance.start();
  };

  JsTestServer.RemoteControl.prototype.start = function() {
    this.poll();
  };

  JsTestServer.RemoteControl.prototype.poll = function() {
    var self = this;
    JsTestServer.xhrGet("/remote_control/commands", function(request) {
      if(request.status == 200) {
        var messages = eval(request.responseText);
        for(var i=0; i < messages.length; i++) {
          eval(messages[i].javascript);
        }
        setTimeout(function() {
          self.poll();
        }, 100);
      };
    });
  };
})();