begin
  require 'cucumber/rake/task'
  require 'spec/rake/spectask'

  namespace :rcov do
    Cucumber::Rake::Task.new(:cucumber_run) do |t|
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
    task :all => ["rcov:clean", "rcov:cucumber_run", "rcov:rspec_run"]
  
    task :clean do |t|
      rm "coverage.data" if File.exist?("coverage.data")
    end
  
    desc "Run only rspecs"
    task :rspec => ["rcov:clean", "rcov:rspec_run"]
  
    desc "Run only cucumber"
    task :cucumber => ["rcov:clean", "rcov:cucumber_run"]

  end
rescue
  desc 'ci rake task not available (cucumber or rspec not installed)'
  task :ci do
    abort 'CI rake task is not available. Be sure to install cucumber and/or rspec as a gem or plugin'
  end
end