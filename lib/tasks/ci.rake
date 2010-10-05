require 'cucumber/rake/task'
require 'spec/rake/spectask'

namespace :ci do
  Cucumber::Rake::Task.new(:cucumber_run) do |t|
    t.profile = 'ci'
    t.rcov = true
    t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/ --aggregate coverage.data}
    t.rcov_opts << %[-o "coverage"]
  end
  
  Spec::Rake::SpecTask.new(:rspec_run) do |t|
    t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = lambda do
      IO.readlines("#{RAILS_ROOT}/spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
    end
  end
  
  desc "Run both specs and features to generate aggregated coverage"
  task :all => ["db:migrate", "rcov:clean", "ci:cucumber_run", "ci:rspec_run"]
  
  desc "Run only rspecs"
  task :rspec => ["rcov:clean", "ci:rspec_run"]
  
  desc "Run only cucumber"
  task :cucumber => ["rcov:clean", "ci:cucumber_run"]
end