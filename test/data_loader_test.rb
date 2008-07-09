require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib', 'ar_importer')

# Note, before running this test suite, please execute the create.sql
# file located in the test directory.
class PipedTest < Test::Unit::TestCase
  def initialize(value)
    super(value)
  end
  
  def setup
    `mysql < create.sql`
    
    @options = {
      :file_name => "./people_data.txt",
      :database => "ar_importer_test"
    }
    
    @dl = DataLoader.new(@options)
    
  end
  
  def test_table_name
    assert_equal('people_data', @dl.options[:table_name])
  end
  
  def test_data_load
    @dl.load_data
    assert_equal(3, @dl.rows_loaded)
    
    
  end
  
end