require 'rubygems'
require 'delimited_file'
require File.join(File.dirname(__FILE__), '../lib/ar_importer')

describe ARImporter do
  before(:each) do
    
    @options = {
      :file_name => File.join(File.dirname(__FILE__), './people_data.txt')
    }
    
    @connection_options = {
      :database => 'ar_importer_test',
      :adapter  => 'mysql',
      :username => 'root',
      :password => '',
      :host     => 'localhost' 
    }

    @ai = ARImporter.new(@options, @connection_options)
    
  end
  
  it "should infer the tablename from the supplied file" do
    @ai.table_name.should == 'people_data'
  end
  
  it "should load the test data into the database" do
    lambda {@ai.load_data}.should change(@ai, :database_rows).by(3)
  end
end