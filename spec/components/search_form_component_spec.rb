require "rails_helper"

RSpec.describe SearchFormComponent, type: :component do
  include Rails.application.routes.url_helpers
  it "renders the search form with the address field and submit button" do
    render_inline(described_class.new(address: "New York"))

    expect(page).to have_selector("form[action='#{weather_search_path}']")
    expect(page).to have_field("address", with: "New York")
    expect(page).to have_button("Search")
  end
end
