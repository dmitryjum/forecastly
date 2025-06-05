require "rails_helper"

RSpec.describe "WeatherController", type: :request do
  let(:address) { "New York, NY" }
  let(:fetcher_result) do
    {
      city: address,
      current: { temp: 70, weekday: "Monday", description: "Sunny", humidity: 60, wind: "5 mph" },
      daily: [
        { name: "Mon", description: "Sunny", temp: 70 },
        { name: "Tue", description: "Cloudy", temp: 65 }
      ]
    }
  end

  before do
    Rails.cache.clear
  end

  it "renders the index with search form and placeholder" do
    get weather_index_path
    expect(response.body).to include(weather_search_path)
    expect(response.body).to include("Enter a city in US to get the current weather and forecast!")
    expect(response.body).to include("Search")
    expect(response.body).to include('turbo-frame')
  end

  it "includes a turbo frame tag with default address for lazy loading" do
    get weather_index_path
    expect(response.body).to include('turbo-frame data-loading-target="forecast" id="forecast" src="/weather/search?address=New+York+NY"')
    expect(response.body).to include(weather_search_path(address: "New York NY"))
  end

  it "returns a 200 response and assigns forecasts for a valid address" do
    allow(WeatherFetcher).to receive(:new).with(anything).and_return(double(call: fetcher_result))

    get weather_search_path, params: { address: address }

    expect(response).to have_http_status(:ok)
    expect(assigns(:current_forecast)).to eq(fetcher_result[:current])
    expect(assigns(:daily_forecast)).to eq(fetcher_result[:daily])
    expect(assigns(:from_cache)).to be_falsey
    expect(assigns(:error)).to be_nil
  end

  it "reads result from cache if present" do
    Rails.cache.write("weather-fetcher-#{address.parameterize}", fetcher_result, expires_in: 30.minutes)

    get weather_search_path, params: { address: address }

    expect(assigns(:current_forecast)).to eq(fetcher_result[:current])
    expect(assigns(:from_cache)).to be_truthy
  end

  it "assigns error if WeatherFetcher returns error" do
    error_result = { error: "Could not geocode address" }
    allow(WeatherFetcher).to receive(:new).with(anything).and_return(double(call: error_result))

    get weather_search_path, params: { address: address }

    expect(assigns(:current_forecast)).to be_nil
    expect(assigns(:error)).to eq("Could not geocode address")
  end
end
