class WeatherController < ApplicationController
  def index
    # Initial empty page
  end

  def search
    address = params[:city]
    @city = address
    @current_forecast = mock_current_forecast
    @daily_forecast = mock_daily_forecast
    respond_to do |format|
      format.turbo_stream
      format.html { render :index }
    end
  end

  private

  def mock_current_forecast
    {
      temp: 4,
      weekday: "Today",
      description: "Cloudy",
      humidity: "81%",
      wind: "12 km/h"
    }
  end

  def mock_daily_forecast
    [
      {
        name: "Fri",
        icon: "https://img.icons8.com/color-glass/42/000000/rain.png",
        description: "Rain",
        temp: 2
      },
      {
        name: "Sat",
        icon: "https://img.icons8.com/color-glass/42/000000/cloud.png",
        description: "Cloudy",
        temp: 4
      },
      {
        name: "Sun",
        icon: "https://img.icons8.com/color-glass/42/000000/partly-cloudy-day.png",
        description: "Partly cloudy",
        temp: 6
      },
      {
        name: "Mon",
        icon: "https://img.icons8.com/color-glass/42/000000/sun.png",
        description: "Sunny",
        temp: 8
      },
      {
        name: "Tues",
        icon: "https://img.icons8.com/color-glass/42/000000/wind.png",
        description: "Windy",
        temp: 5
      }
    ]
  end
end
