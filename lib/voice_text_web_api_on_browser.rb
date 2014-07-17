# -*- coding: utf-8 -*-
require "voice_text_web_api_on_browser/version"
require "sinatra/base"
require "voice_text_api"

module VoiceTextWebApiOnBrowser
  class App < Sinatra::Application
    set :public_folder, File.join(File.dirname(__FILE__), "..", "public")

    def initialize
      super
      @voice_text_api = VoiceTextAPI.new(ENV["VOICE_TEXT_API_TOKEN"])
    end

    get "/" do
      erb :index
    end

    post "/voice" do
      content_type "audio/wave"
      text = params.delete("text")
      speaker = params.delete("speaker").to_sym
      alist = params.map do |k, v|
        if %w(emotion_level pitch speed volume).include?(k)
          [k.to_sym, v.to_i]
        else
          [k.to_sym, v]
        end
      end
      @voice_text_api.tts(text, speaker, Hash[alist])
    end

    template :index do
      <<__EOD__
<html lang-"ja">
<head>
<meta charset="UTF-8">
<title>voice text api on browser</title>
<script src="assets/js/jquery-2.1.1.min.js"></script>
<head>
<body>
<form id="voiceform">
<input type="text" name="text" value="こんにちは，世界">
<div>
話者名
<input type="radio" name="speaker" value="show">show
<input type="radio" name="speaker" value="haruka">haruka
<input type="radio" name="speaker" value="hikari">hikari
<input type="radio" name="speaker" value="takeru">takeru
</div>
<div>
感情カテゴリ
<input type="radio" name="emotion" value="happiness">happiness
<input type="radio" name="emotion" value="anger">anger
<input type="radio" name="emotion" value="sadness">sadness
</div>
<div>
感情レベル
<input type="radio" name="emotion_level" value="1">1
<input type="radio" name="emotion_level" value="2">2
</div>
<input type="submit" value="send">
</form>
<script>
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
</script>
</body>
</html>
__EOD__
    end
  end
end
