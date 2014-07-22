$(function() {
  $("#voiceform").on("submit", function(e) {
    e.preventDefault();
    loadSound("voice", $(this).serialize(), startSound);
  });

  var loadSound = function(url, params, onload) {
    var request = new XMLHttpRequest();
    request.open("POST", url, true);
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    request.responseType = "arraybuffer";
    request.onload = onload;
    request.send(params);
  }

  var startSound = function() {
    var context = new (window.AudioContext || window.webkitAudioContext)();
    context.decodeAudioData(this.response, function(buffer) {
      var source = context.createBufferSource();
      source.buffer = buffer;
      source.connect(context.destination);
      source.start(0);
    });
  }
});
