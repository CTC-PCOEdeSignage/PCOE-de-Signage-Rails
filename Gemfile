source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem 'activeadmin'
gem 'acts_as_list'
gem 'devise'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'draper'
gem 'puma', '~> 3.11'
gem 'rails', '~> 6'
gem 'sass-rails', '~> 5.0'
gem 'sqlite3'
gem 'rest-client'
gem 'uglifier', '>= 1.3.0'

gem 'turbolinks', '~> 5'
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'axe-matchers'
  gem 'faker'
end