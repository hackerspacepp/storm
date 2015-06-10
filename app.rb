require "sinatra"
require "mechanize"
require "rmagick"

set :server, 'webrick'

class Storm < Sinatra::Base

  get '/' do
    fetch_latest_weather
    process_image
    erb :index
  end

  private

  def process_image
    img = Magick::Image.read("public/latest_weather.jpg").first
    img = img.crop(60, 30, 500, 500)
    img.write("public/frontpage.jpg")
  end

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
