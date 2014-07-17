require "./lib/voice_text_web_api_on_browser"

use Rack::Reloader if ENV["RACK_ENV"] == "development"
run VoiceTextWebApiOnBrowser::App
