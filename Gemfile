source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem "aasm"
gem "activeadmin"
gem "acts_as_list"
gem "autoprefixer-rails"
gem "babel-transpiler"
gem "bootstrap", "~> 4.5"
gem "bootstrap_form", "~> 4.0"
gem "config"
gem "daemons"
gem "devise"
gem "delayed_job_active_record"
gem "delayed_cron_job"
gem "dotenv", require: "dotenv/load"
gem "draper"
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
gem "rest-client"
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
  gem "webdrivers"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen"#b, ">= 3.0.5", "< 3.2"
end

group :test do
  gem "axe-matchers"
  gem "rspec_junit_formatter"
  gem "shoulda-matchers"
end