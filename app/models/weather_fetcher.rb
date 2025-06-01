class WeatherFetcher
  require "httparty"

  def initialize(address)
    @address = address
  end

  def call
    coords = Geocoder.search(@address)&.first&.coordinates
    return { error: "Could not geocode address: #{@address}" } unless coords
    lat, lon = coords
    point_response = HTTParty.get("https://api.weather.gov/points/#{lat},#{lon}", headers: headers)
    parsed_response = JSON.parse(point_response)
    return { error: "Unable to provide forecast for your location. Make sure it's in the USA" } unless point_response.success?
    forecast_url = parsed_response.dig("properties", "forecast")
    hourly_url = parsed_response.dig("properties", "forecastHourly")
    return { error: "Forecast URLs not found within api.weather.gov." } unless forecast_url && hourly_url

    forecast_response = JSON.parse(HTTParty.get(forecast_url, headers: headers).body)
    hourly_response = JSON.parse(HTTParty.get(hourly_url, headers: headers).body)
    return { error: "Failed to retrieve forecast data. Try different location or try again later" } unless forecast_response && hourly_response
    {
      city: @address,
      current: build_current_forecast(hourly_response),
      daily: build_daily_forecast(forecast_response)
    }
  end

  private

  def headers
    {
      "User-Agent" => ENV["WEATHER_GOV_USER_AGENT"] || "Forecastly, (test@example.com)"
    }
  end

  def build_current_forecast(response)
    period = response.dig("properties", "periods")&.first
    return {} unless period
    {
      temp: period["temperature"],
      weekday: Date.parse(period["startTime"]).strftime("%A"),
      description: period["shortForecast"],
      humidity: period["relativeHumidity"]["value"],
      wind: period["windSpeed"]
    }
  end

  def build_daily_forecast(response)
    periods = response.dig("properties", "periods")
    return [] unless periods
    periods.select { |p| p["isDaytime"] }.first(5).map do |day|
      {
        name: Date.parse(day["startTime"]).strftime("%a"),
        description: day["shortForecast"],
        temp: day["temperature"]
      }
    end
  end
end
