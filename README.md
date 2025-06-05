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

- Ruby 3.4.4+
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
## Running the Test Suite
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
### Work Challenges
1. **Multi-Database Configuration for Rails 8 on Heroku**
* Navigating Rails’ multi-database setup (primary, cache, queue, cable) and aligning it with Heroku’s environment and connection URLs.
* Resolving errors related to missing or misconfigured database roles in production.

2. **Solid Cache and Solid Queue Integration**
* Understanding how to configure and migrate Solid Cache and Solid Queue, especially when using a single database versus multiple databases.
* Heroku deployment issues with Solid Cache and Database configuration related to it. Had to find a way to run all the migrations in a single database and play around with database.yml config files to make sure it works and caches correctly in all 3 environments: dev, test, prod (Heroku).
* Ensuring cache writes/read work correctly in both local and production environments.
3. **Geocoder Reliability and Error Handling**
* Handling edge cases where Geocoder returns empty results or times out, and ensuring the user receives a clear error message instead of a spinner or blank state.
* Configuring Geocoder with proper caching and timeouts for resilience.
4. **Frontend Responsiveness and UX**
* Ensuring the UI provides clear feedback for loading and error states

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
