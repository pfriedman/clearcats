namespace :turbocats do
  desc "Import the turbocats data."
  task :import => :environment do
    PaperTrail.enabled = false
    
    Turbocats::Importer.run
    
    PaperTrail.enabled = true
  end
end