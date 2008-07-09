require 'rubygems'
require 'delimited_file'
require 'ar_importer'


@options = {
  :file_name => "./posts.txt",  
	:parser => DelimitedFile.new("./posts.txt", :field_delimiter => "|", :row_delimiter => "\r\n")
}

@connection_options = {
	:database => "example_db",
	:adapter  => "jdbc",
	:driver => "com.microsoft.sqlserver.jdbc.SQLServerDriver", # using the SQL Server 2005 jdbc driver from microsoft
	:username => "rails_user",
	:password => "letmein",
	:url => "jdbc:sqlserver://MACHINENAME;",
	:host => "MACHINENAME"
}


dl = DataLoader.new(@options, @connection_options)
puts dl.extract_table_name
dl.load_data