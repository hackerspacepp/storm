require "sinatra"
require "mechanize"

set :server, 'webrick'

class Storm < Sinatra::Base

  get '/' do
    fetch_latest_weather
    erb :index
  end

  private

  def agent
    @agent ||= Mechanize.new
    @agent.pluggable_parser.default = Mechanize::Download
    @agent
  end

  def latest_weather_url
    last_image_path = agent
      .get("http://cambodiameteo.com/slideshow?menu=117")
      .search(".//script")
      .last
      .to_s
      .scan(/theImagesComplete\[29\]\s=\s\"(.*)\"/)
      .first
      .first
    "http://cambodiameteo.com/#{last_image_path}"
  end

  def fetch_latest_weather
    agent.get(latest_weather_url).save!("public/latest_weather.jpg")
  end

end
