class ForecastCurrentComponent < ViewComponent::Base
  def initialize(current:)
    @current = current
  end
end
