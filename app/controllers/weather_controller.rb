class WeatherController < ApplicationController
  def index
  end

  def search
    result = WeatherFetcher.new(params[:city]).call

    if result[:error]
      @city = params[:city]
      @current_forecast = nil
      @daily_forecast = nil
      @error = result[:error]
    else
      @city = result[:city]
      @current_forecast = result[:current]
      @daily_forecast = result[:daily]
    end
    respond_to do |format|
      format.turbo_stream
      format.html { render :index }
    end
  end
end
