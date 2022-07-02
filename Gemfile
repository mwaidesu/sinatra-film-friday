source 'http://rubygems.org'
ruby '2.7.4'

gem 'activerecord', require: 'active_record'
gem 'bcrypt', git: 'https://github.com/codahale/bcrypt-ruby.git', require: 'bcrypt'
gem 'rake'
gem 'require_all'
gem 'shotgun'
gem 'sinatra'
gem 'sinatra-activerecord', require: 'sinatra/activerecord'
gem 'thin'
gem 'puma'

gem 'rack-flash3'

group :development do
 gem 'sqlite3'
 gem "tux"
end

group :production do
 gem 'pg'
end

group :test do
  gem 'capybara'
  gem 'rspec'
  # gem 'selenium'
  gem 'database_cleaner', git: 'https://github.com/bmabey/database_cleaner.git'
  gem 'rack-test'

  gem 'pry'
  # comment out sqlite gem if using postgresql for test and development database
  # gem 'sqlite3', '~> 1.4'
end
