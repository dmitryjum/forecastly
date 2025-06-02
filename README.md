# Forecastly

Forecastly is a modern Rails 8 application that provides weather forecasts for US cities. It features a clean, mobile-friendly UI, fast responses via caching, and a modular, object-oriented codebase. The app is currently **deployed** to: https://forecastly-f42b147e3fc1.herokuapp.com/

---

## Features

- **Search for weather by US city/address**
- **Current and 5-day forecast display**
- **Turbo Frames for fast, partial page updates**
- **Solid Cache for robust, database-backed caching**
- **Mobile-first responsive design (Tailwind CSS)**
- **Object decomposition for maintainable code**

---

## Installation

### Prerequisites

- Ruby 3.3+
- Rails 8+
- PostgreSQL

### Setup Steps

1. **Clone the repository**

   ```sh
   git clone https://github.com/yourusername/forecastly.git
   cd forecastly

2. **Install dependencies**
    ```sh
    bundle install

3. **Set up environment variables**
  Create a .env file (or set in your shell) for any secrets. For weather.gov API, you can set a user agent:
    ```sh
    WEATHER_GOV_USER_AGENT="Forecastly, (your-email@example.com)"

4. Set up the databases
    ```sh
    bin/rails db:create
    bin/rails db:migrate

5. Install and migrate Solid Cache
  Solid Cache uses a separate database for caching. The default config uses forecastly_cache

6. Start the Rails server
    ```sh
    bin/dev or rails s

    Visit http://localhost:3000 in your browser.

  ---
## Running the Test Suit
1. Prepare the test database
    ```sh
    bin/rails db:test:prepare
    bin/rails db:create
    bin/rails db:migrate

2. Run Rspec
    ```sh
    rspec

---

## Object Decomposition: `WeatherFetcher`

The `WeatherFetcher` class encapsulates all logic for retrieving and parsing weather data.

### Responsibilities

* Geocodes the user’s address using Geocoder.
* Fetches weather data from [api.weather.gov](https://api.weather.gov/).
* Parses and structures current and daily forecast data.
* Handles error cases (invalid address, API errors, etc).

### Design Considerations

* **Single Responsibility:** All weather-fetching logic is isolated from controllers and views.
* **Testability:** The class is easily stubbed/mocked in tests.
* **Extensibility:** If you want to swap APIs or add more data, you only need to update this class.
* **Caching:** The controller caches the result of `WeatherFetcher#call` using Solid Cache for performance.
* **Geocoder setup:** Geocoder is cached using Rails Solid Cache and it's timeout set for 20 seconds for resilience

---

## Project Structure

* `app/controllers/weather_controller.rb` — Handles search and caching logic.
* `app/models/weather_fetcher.rb` — Fetches and parses weather data.
* `app/components/forecast_current_component.rb` — Renders current weather.
* `app/components/forecast_daily_component.rb` — Renders daily forecast.
* `app/views/weather/index.html.erb` — Main page and search form.
* `app/views/weather/search.html.erb` — Turbo Frame response for search.

---

## Notes

* **Caching:** Uses Solid Cache for production-grade, database-backed caching.
* **API Usage:** Please set a valid `WEATHER_GOV_USER_AGENT` for responsible API usage.
* **Testing:** Uses RSpec, Capybara, and ViewComponent test helpers.
