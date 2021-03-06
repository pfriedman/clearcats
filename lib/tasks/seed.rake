require 'active_record/fixtures'

namespace :nucats do
  namespace :db do
    desc "Seed the database with once/ and always/ fixtures."
    task :seed => :environment do 
      load_fixtures "seed/once"
      load_fixtures "seed/always", :always
    end
 
    desc "Seed the database with develop/ fixtures."
    task :develop => :environment do 
      load_fixtures 'seed/develop', :always
      load_ctsa_data
    end
 
    private
    
      def load_ctsa_data
        file_path = File.expand_path(File.dirname(__FILE__) + '../../../doc/ctsa/2010 CTSA XML Schema.xsd')
        reader = CtsaSchemaReader.new(file_path)
        reader.process
      end
 
      def load_fixtures(dir, always = false)
        Dir.glob(File.join(RAILS_ROOT, 'db', dir, '*.yml')).each do |fixture_file|
          table_name = File.basename(fixture_file, '.yml')
 
          if table_empty?(table_name) || always
            truncate_table(table_name)
            Fixtures.create_fixtures(File.join('db/', dir), table_name)
          end
        end
      end  
 
      def table_empty?(table_name)
        quoted = connection.quote_table_name(table_name)
        connection.select_value("SELECT COUNT(*) FROM #{quoted}").to_i.zero?
      end
 
      def truncate_table(table_name)
        quoted = connection.quote_table_name(table_name)
        connection.execute("DELETE FROM #{quoted}")
      end
 
      def connection
        ActiveRecord::Base.connection
      end
  end
end