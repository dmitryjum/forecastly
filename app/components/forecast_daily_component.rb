class ForecastDailyComponent < ViewComponent::Base
  def initialize(days:)
    @days = days
  end
end
