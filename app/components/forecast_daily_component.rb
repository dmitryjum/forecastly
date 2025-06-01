class ForecastDailyComponent < ViewComponent::Base
  def initialize(days:)
    @days = days
  end

  def icon_for(description)
    icons = {
      "Rain" => "https://img.icons8.com/color-glass/42/000000/rain.png",
      "Cloud" => "https://img.icons8.com/color-glass/42/000000/cloud.png",
      "Partly cloudy" => "https://img.icons8.com/color-glass/42/000000/partly-cloudy-day.png",
      "Sunny" => "https://img.icons8.com/color-glass/42/000000/sun.png",
      "Wind" => "https://img.icons8.com/color-glass/42/000000/wind.png"
    }
    icons[description] || "https://img.icons8.com/color-glass/42/000000/partly-cloudy-day.png"
  end
end
