class SearchFormComponent < ViewComponent::Base
  def initialize(city:)
    @city = city
  end
end
