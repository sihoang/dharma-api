ENV['RACK_ENV'] = 'test'
require 'rspec'
require 'rack/test'
require './app/init.rb'
require './app/routes.rb'
require 'json'

RSpec.configure do |config|
  
  config.include Rack::Test::Methods
  
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  Mail.defaults do
    delivery_method :test # in practice you'd do this in spec_helper.rb
  end

  config.before(:all) do
    talks = JSON.parse(open(File.dirname(__FILE__) + '/fixtures/talks.json').read)
    # load talks.json
    talks.each do |talk|
      Talk.create(talk)
    end

    # load speakers.json
    speakers = JSON.parse(open(File.dirname(__FILE__) + '/fixtures/speakers.json').read)
    speakers.each do |speaker|
      Speaker.create(speaker)
    end

    Key.create({
      :api_key => '123',
      :email => 'mrbuddha@548bc.com',
      :status => 'active'
    })
  end

  config.after(:all) do
    Talk.destroy_all()
    Speaker.destroy_all()
    Key.destroy_all()
  end
end

def app
  Dharma
end