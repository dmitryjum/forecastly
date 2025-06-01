class ForecastDailyComponent < ViewComponent::Base
  def initialize(days:)
    @days = days
  end

  def icon_for(description)
    icons = [
      [ /rain|shower|thunderstorm/i, "https://img.icons8.com/color-glass/42/000000/rain.png" ],
      [ /partly/i,                  "https://img.icons8.com/color-glass/42/000000/partly-cloudy-day.png" ],
      [ /cloud|overcast/i,          "https://img.icons8.com/color-glass/42/000000/cloud.png" ],
      [ /sun|clear/i,               "https://img.icons8.com/color-glass/42/000000/sun.png" ],
      [ /wind/i,                    "https://img.icons8.com/color-glass/42/000000/wind.png" ]
    ]

  icons.each do |pattern, icon|
    return icon if description =~ pattern
  end

  "https://img.icons8.com/color-glass/42/000000/partly-cloudy-day.png"
  end
end
