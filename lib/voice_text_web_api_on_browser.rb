# -*- coding: utf-8 -*-
require "voice_text_web_api_on_browser/version"
require "sinatra/base"

module VoiceTextWebApiOnBrowser
  class App < Sinatra::Application
    get "/" do
      "Hello World!"
    end
  end
end
