source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.3.6'
# Use Puma as the app server
gem 'puma', '~> 3.12'
gem 'rack-cors', require: 'rack/cors'
gem 'jbuilder'
gem 'rbnacl'
gem 'httparty'
gem 'responders'
gem 'rack-reverse-proxy', :require => "rack/reverse_proxy"
gem 'gpgme'
gem 'web3-eth'
gem 'eth'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rswag'

# update for security fixes
gem 'loofah', '~> 2.3', '>= 2.3.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
