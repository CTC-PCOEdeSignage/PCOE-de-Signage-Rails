source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem "aasm"
gem "activeadmin"
gem "acts_as_list"
gem "autoprefixer-rails"
gem "babel-transpiler"
gem "bootstrap", "~> 5"
gem "bootstrap_form", "~> 5"
gem "config"
gem "daemons"
gem "delayed_cron_job"
gem "delayed_job_active_record"
gem "devise"
gem "dotenv", require: "dotenv/load"
gem "draper"
gem "dry-configurable", "1.2.0"
gem "dry-core", "1.0.2"
gem "dry-inflector", "1.1.0"
gem "dry-initializer", "3.1.1"
gem "dry-logic", "1.5.0"
gem "dry-schema", "1.13.4"
gem "dry-types", "1.7.2"
gem "dry-validation", "1.10.0"
gem "formtastic"
gem "premailer-rails"
gem "puma", "~> 6"
gem "rails", "~> 7.1"
gem "rectify"
gem "recurring_select", github: "gregschmit/recurring_select", ref: "5dd3177e7ac4c04bed3e952996ffcb57b87481c9"
gem "redcarpet"
gem "rounding"
gem "rqrcode"
gem "sass-rails", "~> 6.0"
gem "stimulusjs-rails", "~> 1.1.1"
gem "uglifier", ">= 1.3.0"
gem "sqlite3"

gem "turbolinks", "~> 5"
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
end

group :test do
  gem "axe-matchers"
  gem "rspec_junit_formatter"
  gem "rspec-retry"
  gem "shoulda-matchers"
end