class WeatherController < ApplicationController
  def search
    address = params[:address]
    cache_key = "weather-fetcher-#{address.parameterize}"

    cached_result = Rails.cache.read(cache_key)
    @from_cache = false
    if cached_result
      result = cached_result
      @from_cache = true
    else
      result = WeatherFetcher.new(address).call
      Rails.cache.write(cache_key, result, expires_in: 30.minutes) unless result[:error]
    end

    if result[:error]
      @city = params[:address]
      @current_forecast = nil
      @daily_forecast = nil
      @error = result[:error]
    else
      @city = result[:city]
      @current_forecast = result[:current]
      @daily_forecast = result[:daily]
    end
  end
end
