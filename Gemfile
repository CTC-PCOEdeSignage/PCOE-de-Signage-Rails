source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem "aasm"
gem "activeadmin"
gem "acts_as_list"
gem "autoprefixer-rails"
gem "benchmark" # stdlib gem since Ruby 4.0; delayed_job requires it
gem "bootstrap", "~> 5"
gem "bootstrap_form", "~> 5.5.0"
gem "config"
gem "daemons"
gem "delayed_cron_job"
gem "delayed_job_active_record"
gem "devise"
gem "dotenv", require: "dotenv/load"
gem "draper"
gem "formtastic"
gem "importmap-rails"
gem "premailer-rails"
gem "puma", "~> 7"
gem "rails", "~> 8.1.0"
gem "recurring_select", github: "CTC-PCOEdeSignage/recurring_select", ref: "9f7d08279d7aedcb62f91f68f9e181057053a6a1"
gem "redcarpet"
gem "rounding"
gem "rqrcode"
gem "dartsass-sprockets"
gem "stimulus-rails"
gem "sqlite3"

gem "turbo-rails"
gem "bootsnap", ">= 1.1.0", require: false

gem "nokogiri"#, ">= 1.5"

group :development, :test do
  gem "capybara"
  gem "factory_bot_rails"
  gem "faker"
  gem "letter_opener"
  gem "pry-rails"
  gem "rspec-rails"#, "~> 4.0.0"
  gem "selenium-webdriver", "~> 4.25.0"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen"#b, ">= 3.0.5", "< 3.2"
  gem "bummr"
  gem "brakeman", require: false
  gem "bundler-audit", require: false
end

group :test do
  gem "axe-core-rspec"
  gem "rspec_junit_formatter"
  gem "rspec-retry"
  gem "shoulda-matchers"
end