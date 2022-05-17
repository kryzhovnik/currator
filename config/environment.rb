require 'bundler/setup'
Bundler.require(:default)

if ENV['RACK_ENV'] == 'development'
  require 'dotenv'
  Dotenv.load('.env')
end

Dir["./app/**/*.rb"].each { |file| require file }
