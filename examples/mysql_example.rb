require 'rubygems'
require 'delimited_file'
# require 'ar_importer'
require File.join(File.dirname(__FILE__), '../lib/ar_importer')

@options = {
  :file_name => File.join(File.dirname(__FILE__), '../spec/people_data.txt')
}

@connection_options = {
  :database => 'ar_importer_test',
  :adapter  => 'mysql',
  :username => 'root',
  :password => '',
  :host     => 'localhost' 
}

@ai = ARImporter.new(@options, @connection_options)
@ai.load_data