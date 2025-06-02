require "rails_helper"

RSpec.describe WeatherFetcher do
  let(:address) { "New York, NY" }
  let(:coords) { [ 40.7128, -74.006 ] }

  before do
    allow(Geocoder).to receive(:search).with(address).and_return([ double(coordinates: coords) ])

    stub_request(:get, %r{https://api.weather.gov/points/#{coords[0]},#{coords[1]}})
      .to_return(
        status: 200,
        body: {
          properties: {
            forecast: "https://api.weather.gov/gridpoints/OKX/33,35/forecast",
            forecastHourly: "https://api.weather.gov/gridpoints/OKX/33,35/forecast/hourly"
          }
        }.to_json,
        headers: { "Content-Type" => "application/geo+json" }
      )

    stub_request(:get, "https://api.weather.gov/gridpoints/OKX/33,35/forecast")
      .to_return(
        status: 200,
        body: {
          properties: {
            periods: [
              {
                isDaytime: true,
                startTime: "2024-06-02T06:00:00-04:00",
                shortForecast: "Sunny",
                temperature: 75
              },
              {
                isDaytime: true,
                startTime: "2024-06-03T06:00:00-04:00",
                shortForecast: "Rain",
                temperature: 70
              }
            ]
          }
        }.to_json,
        headers: { "Content-Type" => "application/geo+json" }
      )

    stub_request(:get, "https://api.weather.gov/gridpoints/OKX/33,35/forecast/hourly")
      .to_return(
        status: 200,
        body: {
          properties: {
            periods: [
              {
                temperature: 74,
                startTime: "2024-06-02T12:00:00-04:00",
                shortForecast: "Sunny",
                windSpeed: "5 mph",
                relativeHumidity: { value: 60 }
              }
            ]
          }
        }.to_json,
        headers: { "Content-Type" => "application/geo+json" }
      )
  end

  it "returns current and daily forecasts for a valid US address" do
    result = WeatherFetcher.new(address).call

    expect(result[:city]).to eq(address)
    expect(result[:current]).to include(
      temp: 74,
      weekday: "Sunday",
      description: "Sunny",
      humidity: 60,
      wind: "5 mph"
    )
    expect(result[:daily]).to be_an(Array)
    expect(result[:daily].first).to include(
      name: "Sun",
      description: "Sunny",
      temp: 75
    )
    expect(result[:error]).to be_nil
  end

  it "returns an error for an ungeocodable address" do
    allow(Geocoder).to receive(:search).with("Mars").and_return([])
    result = WeatherFetcher.new("Mars").call
    expect(result[:error]).to match(/Could not geocode address/)
  end

  it "returns an error if Geocoder raises an exception" do
    allow(Geocoder).to receive(:search).with(address).and_raise(StandardError)
    result = WeatherFetcher.new(address).call
    expect(result[:error]).to match(/Could not geocode address/)
  end

  it "returns an error if API response is missing forecast URLs" do
    stub_request(:get, %r{https://api.weather.gov/points/.*})
      .to_return(status: 200, body: { properties: {} }.to_json)
    result = WeatherFetcher.new(address).call
    expect(result[:error]).to match(/Forecast URLs not found/)
  end

  it "returns an error if forecast API fails" do
    stub_request(:get, "https://api.weather.gov/gridpoints/OKX/33,35/forecast")
      .to_return(status: 500, body: "")
    result = WeatherFetcher.new(address).call
    expect(result[:error]).to match(/Failed to retrieve forecast data/)
  end
end
