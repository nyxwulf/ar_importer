require 'rubygems'
require 'delimited_file'
require '../lib/ar_importer'

describe ARImporter do
  before(:each) do
    
    @options = {
      :file_name => './people_data.txt'
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
    @ai.options[:table_name].should == 'people_data'
  end
  
  it "should load the test data into the database" do
    @ai.set_base_table('people_data')
    lambda {@ai.load_data}.should change(@ai, :database_rows).by(3)
  end
end