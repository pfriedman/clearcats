# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'tasks/surveyor'

require 'rubygems'

# Install:
#  sudo gem install ci_reporter
# gem 'ci_reporter'
# require 'ci/reporter/rake/test_unit' # use this if you're using Test::Unit

if Rails.env == "development"
  require 'metric_fu'

  MetricFu::Configuration.run do |config|
    #define which metrics you want to use
    config.metrics  = [:churn, :saikuro, :stats, :flog, :flay, :rails_best_practices, :reek, :roodi]
    config.graphs   = [:flog, :flay, :stats, :rails_best_practices, :reek, :roodi]

    config.saikuro = { :output_directory => 'tmp/metric_fu/saikuro', 
                       :input_directory  => ['app', 'lib'],
                       :cyclo            => "",
                       :filter_cyclo     => "0",
                       :warn_cyclo       => "5",
                       :error_cyclo      => "7",
                       :formater         => "text" }

    config.flay  = { :dirs_to_flay  => ['app', 'lib'],
                     :minimum_score => 10,
                     :filetypes     => ['rb'] }

    config.flog  = { :dirs_to_flog  => ['app', 'lib'] }

    config.reek  = { :dirs_to_reek  => ['app', 'lib'] }
  
    config.roodi = { :dirs_to_roodi => ['app', 'lib'] }
  end
end