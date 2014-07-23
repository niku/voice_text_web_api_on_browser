$(function() {
  $("#voiceform").on("submit", function(e) {
    e.preventDefault();
    $("#flash-notice").text("");
    loadSound("voice", $(this).serialize(), startSound, flashNotice);
  });

  var loadSound = function(url, params, onSuccess, onFailure) {
    var request = new XMLHttpRequest();
    request.open("POST", url, true);
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    request.responseType = "arraybuffer";
    request.onload = function(e) {
      if (this.status === 200) {
        console.log("success");
        onSuccess(this.response);
      } else {
        console.log("failure");
        onFailure(this.response);
      }
    };
    request.send(params);
  };

  var startSound = function(arrayBuffer) {
    var context = new (window.AudioContext || window.webkitAudioContext)();
    context.decodeAudioData(arrayBuffer, function(buffer) {
      var source = context.createBufferSource();
      source.buffer = buffer;
      source.connect(context.destination);
      source.start(0);
    });
  };

  var flashNotice = function(arrayBuffer) {
    var string = String.fromCharCode.apply(null, new Uint8Array(arrayBuffer)),
    json = $.parseJSON(string),
    message = json.error.message;
    $("#flash-notice").text(message);
  };
});
