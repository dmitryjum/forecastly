require "rails_helper"

RSpec.describe ForecastCurrentComponent, type: :component do
  let(:current) do
    {
      temp: 57,
      weekday: "Monday",
      description: "Sunny",
      humidity: 62,
      wind: "5 mph"
    }
  end

  it "renders city, temperature, weekday, description, humidity, and wind" do
    render_inline(described_class.new(city: "New York NY", current: current, from_cache: false))

    expect(page).to have_text("New York NY")
    expect(page).to have_text("57")
    expect(page).to have_text("Monday")
    expect(page).to have_text("Sunny")
    expect(page).to have_text("Humidity: 62%")
    expect(page).to have_text("Wind: 5 mph")
  end

  it "shows the cached pill if from_cache is true" do
    render_inline(described_class.new(city: "New York NY", current: current, from_cache: true))
    expect(page).to have_text("Cached")
  end

  it "does not show the cached pill if from_cache is false" do
    render_inline(described_class.new(city: "New York NY", current: current, from_cache: false))
    expect(page).not_to have_text("Cached")
  end
end
