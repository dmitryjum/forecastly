require "rails_helper"

RSpec.describe ForecastDailyComponent, type: :component do
  let(:days) do
    [
      { name: "Mon", description: "Sunny", temp: 70 },
      { name: "Tue", description: "Rain", temp: 65 },
      { name: "Wed", description: "Cloudy", temp: 60 }
    ]
  end
  subject(:component) { described_class.new(days: []) }
  describe "renders the component" do
    it "renders each day's name, description, and temperature" do
      render_inline(described_class.new(days: days))

      days.each do |day|
        expect(page).to have_text(day[:name])
        expect(page).to have_text(day[:description])
        expect(page).to have_text("#{day[:temp]}°")
      end
    end

    it "renders the correct weather icon for each day" do
      render_inline(described_class.new(days: days))

      expect(page).to have_css("img[src*='sun.png']")
      expect(page).to have_css("img[src*='rain.png']")
      expect(page).to have_css("img[src*='cloud.png']")
    end
  end

  describe "#icon_for" do
    it "returns rain icon for rain-related descriptions" do
      expect(component.icon_for("Heavy Rain")).to include("rain.png")
      expect(component.icon_for("Chance Showers And Thunderstorms")).to include("rain.png")
    end

    it "returns partly cloudy icon for partly-related descriptions" do
      expect(component.icon_for("Partly Sunny")).to include("partly-cloudy-day.png")
      expect(component.icon_for("Partly Cloudy")).to include("partly-cloudy-day.png")
    end

    it "returns cloud icon for cloud or overcast descriptions" do
      expect(component.icon_for("Cloudy")).to include("cloud.png")
      expect(component.icon_for("Overcast")).to include("cloud.png")
    end

    it "returns sun icon for sun or clear descriptions" do
      expect(component.icon_for("Sunny")).to include("sun.png")
      expect(component.icon_for("Clear")).to include("sun.png")
    end

    it "returns wind icon for wind descriptions" do
      expect(component.icon_for("Windy")).to include("wind.png")
    end

    it "returns partly cloudy icon as default" do
      expect(component.icon_for("Fog")).to include("partly-cloudy-day.png")
    end
  end
end
