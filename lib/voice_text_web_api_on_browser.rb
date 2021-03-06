# -*- coding: utf-8 -*-
require "voice_text_web_api_on_browser/version"
require "sinatra/base"
require "voice_text_api"

module VoiceTextWebApiOnBrowser
  class App < Sinatra::Application
    configure :development do
      require "sinatra/reloader"
      register Sinatra::Reloader
    end

    set :public_folder, File.join(File.dirname(__FILE__), "..", "public")

    def initialize
      super
      @voice_text_api = VoiceTextAPI.new(ENV["VOICE_TEXT_API_TOKEN"])
    end

    get "/" do
      send_file File.join(settings.public_folder, "index.html")
    end

    post "/voice" do
      begin
        text = params.delete("text")
        speaker = params.delete("speaker").to_sym
        alist = params.map do |k, v|
          if %w(emotion_level pitch speed volume).include?(k)
            [k.to_sym, v.to_i]
          else
            [k.to_sym, v]
          end
        end
        voice = @voice_text_api.tts(text, speaker, Hash[alist])
        content_type "audio/wave"
        body voice
      rescue => e
        content_type "application/json"
        halt 503, e.message
      end
    end
  end
end
