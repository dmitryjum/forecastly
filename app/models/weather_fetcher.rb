# app/models/weather_fetcher.rb
class WeatherFetcher
  require 'httparty'

  def initialize(address)
    @address = address
  end

  def call
    coords = Geocoder.search(@address)&.first&.coordinates
    query = coords ? coords.join(',') : @address

    response = HTTParty.get("http://api.weatherstack.com/current", query: {
      access_key: ENV['WEATHERSTACK_API'],
      query: query,
      forecast_days: 5
    })
    if response.success? && response["location"]
      {
        city: response["location"]["name"],
        current: build_current_forecast(response),
        daily: mock_daily_forecast
      }
    else
      { error: "Could not fetch weather for #{@address}" }
    end
  end

  private

  def build_current_forecast(api_response)
    {
      temp: api_response["current"]["temperature"],
      weekday: Date.parse(api_response["location"]["localtime"]).strftime("%A"),
      description: api_response["current"]["weather_descriptions"].join(", "),
      humidity: "#{api_response["current"]["humidity"]}",
      wind: "#{api_response["current"]["wind_speed"]} km/h"
    }
  end

  def build_daily_forecast(api_response)
    days = []
    forecast_hash = api_response["forecast"] || {}
    forecast_hash.first(5).each do |date, data|
      next unless data
      days << {
        name: Date.parse(date).strftime("%a"),
        description: data["weather_descriptions"].first,
        temp: data["avgtemp"] || data["temperature"] || data["mintemp"]
      }
    end
    days
  end

  def mock_daily_forecast
      [
        {
          name: "Fri",
          description: "Rain",
          temp: 2
        },
        {
          name: "Sat",
          description: "Cloudy",
          temp: 4
        },
        {
          name: "Sun",
          description: "Partly cloudy",
          temp: 6
        },
        {
          name: "Mon",
          description: "Sunny",
          temp: 8
        },
        {
          name: "Tues",
          description: "Windy",
          temp: 5
        }
      ]
    end
end
