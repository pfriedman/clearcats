# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','initializers', 'system_config'))

require 'spec/autorun'
require 'spec/rails'

# Factory Girl was not autoloading factories hence the call to Factory.find_definitions
# cf. http://stackoverflow.com/questions/1160004/setup-factory-girl-with-testunit-and-shoulda
require 'factory_girl'
Factory.find_definitions

# Paperclip matchers
require 'paperclip/matchers'

require 'surveyor'
require 'shoulda'

module TestLogins
  def user_login
    Bcsec.authority.valid_credentials?(:user, 'cc_user', 'cc_user')
  end

  def admin_login
    Bcsec.authority.valid_credentials?(:user, 'cc_admin', 'cc_admin')
  end
  
  def faculty_login
    Bcsec.authority.valid_credentials?(:user, 'faculty', 'faculty')    
  end

  def login(as)
    request.env['bcsec'] = Bcsec::Rack::Facade.new(Bcsec.configuration, as)
  end
end

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = Rails.root + '/spec/fixtures/'
  config.include TestLogins

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses its own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
  
  config.include Paperclip::Shoulda::Matchers
end

def will_paginate_collection(collection, page = 1, per_page = 10)
  return WillPaginate::Collection.create(page, per_page) do |pager|
    pager.replace(collection)
    unless pager.total_entries
      pager.total_entries = collection.size
    end
  end
end

class Bcsec::Rack::Facade
  def permit!(*groups)
    true
  end
end