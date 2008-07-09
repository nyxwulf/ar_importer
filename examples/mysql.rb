require 'rubygems'
require 'delimited_file'
require 'ar_importer'

@options = {
  :file_name => '../spec/people_data.txt'
}

@connection_options = {
  :database => 'example_db',
  :adapter  => 'mysql',
  :username => 'root',
  :password => '',
  :host     => 'localhost' 
}

@ai = ARImporter.new(@options, @connection_options)
puts @ai.extract_table_name
@ai.load_data