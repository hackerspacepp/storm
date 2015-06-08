require "sinatra"
require "mechanize"

set :server, 'webrick'

class Storm < Sinatra::Base
  def fetch_latest_weather
    agent = Mechanize.new
    last_image_path = agent
      .get("http://cambodiameteo.com/slideshow?menu=117")
      .search(".//script")
      .last
      .to_s
      .scan(/theImagesComplete\[29\]\s=\s\"(.*)\"/).first.first
    last_image_url = "http://cambodiameteo.com/#{last_image_path}"
    agent.pluggable_parser.default = Mechanize::Download
    agent.get(last_image_url).save!("public/latest_weather.jpg")
  end

  get '/' do
    fetch_latest_weather
    erb :index
  end

end
