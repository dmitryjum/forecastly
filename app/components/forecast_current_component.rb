class ForecastCurrentComponent < ViewComponent::Base
  def initialize(current:, from_cache: false)
    @from_cache = from_cache
    @current = current
  end
end
