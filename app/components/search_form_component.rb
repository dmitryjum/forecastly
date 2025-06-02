class SearchFormComponent < ViewComponent::Base
  def initialize(address:)
    @address = address
  end
end
