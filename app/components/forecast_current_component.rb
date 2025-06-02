class ForecastCurrentComponent < ViewComponent::Base
  def initialize(city:, current:, from_cache: false)
    @from_cache = from_cache
    @current = current
    @city = city
  end
end
