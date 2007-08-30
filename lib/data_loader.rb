# =DataLoader is a simple ActiveRecord loader using the piped parser
# The motivation is to create a simple way to load text files into mysql.

require 'rubygems'
require 'piped'
require 'active_record'

# Loader class used to set the table name and load the data
class Loader < ActiveRecord::Base
  
end

# This is the main harness class that will do the work.
class DataLoader
  # Options are:
  # * adapter - ActiveRecord adapter type, defaults to mysql
  # * host    - The host you are connecting to, defaults to localhost
  # * database - The database you want to work with, no default
  # * table_name - what table you want to load data into.  Defaults to the name of the file without the extension.
  # * file_name - path to the file you want to load
  # * parser - a PipeDelimited parser to parse the data, defaults to nil.  If nil, a new parser will be constructed using the defaults
  def initialize(options = {})
    merge_options options
    establish_connection
    extract_table_name
    @rows_loaded = 0
    @rows_error = 0
  end
  
  attr_accessor :options
  attr_reader :rows_loaded, :rows_error
  
  # Merges supplied options with the default options
  def merge_options(options)
    @options = {
      :table_name => nil,
      :adapter    => 'mysql',
      :host       => 'localhost'
    }.merge(options)
  end

  # Establish a connection to the database using the supplied configuration
  def establish_connection
    ActiveRecord::Base.establish_connection(
      :adapter  => @options[:adapter],
      :host     => @options[:host],
      :database => @options[:database]
    )
  end
  
  # If no table name is supplied, use the name of the file for the table name
  def extract_table_name
    if @options[:table_name].nil?
      fn = @options[:file_name]
      @options[:table_name] = File.basename(fn).gsub(File.extname(fn), '')
    end
  end
  
  # Load the data into the table.
  # This method makes use of the PipeDelimited parser with the default options
  # if you need to specify something other than the default options pass a populated
  # PipeDelimited object in the options has as :parser.
  def load_data
    set_base_table(@options[:table_name])

    pd = nil
    if @options[:parser] == nil
      pd = PipeDelimited.new(@options[:file_name])
    else
      pd = @options[:parser]
    end

      
    
    pd.each_with_index do |row, index|
      begin
        
        load = Loader.new(row)
        load.save
        @rows_loaded += 1
      rescue Exception => ex
        
        @rows_error += 1
        puts "Error saving line #{index}"
        p "Error Info: #{ex}"
        row.keys.each do |key|
          puts "row[#{key}] = #{row[key]}"
        end
        puts
      end
    end
  end
  
  # dynamically bind Loader to the table_name we are loading data for.
  def set_base_table(table_name)
    mystr = <<-EOL
    class Loader < ActiveRecord::Base
      set_table_name '#{table_name}'
    end
    EOL
    
    eval(mystr)
  end
  
end