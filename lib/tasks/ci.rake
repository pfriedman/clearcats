require 'cucumber/rake/task'
require 'spec/rake/spectask'

require 'ci/reporter/rake/rspec'

namespace :ci do
  Cucumber::Rake::Task.new(:cucumber_run) do |t|
    t.profile = 'ci'
    t.rcov = true
    t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/ --aggregate coverage.data}
    t.rcov_opts << %[-o "coverage"]
  end
  
  desc "Run both specs and features to generate aggregated coverage"
  task :all => ["db:migrate", "rcov:clean", "ci:cucumber_run", "ci:rspec_run"]
  
  ENV["CI_REPORTS"] = "reports/spec-xml"
  task :rspec_run => ["ci:setup:rspec", 'rcov:rspec_run']

end