# =ARImporter is a simple ActiveRecord loader using the delimited_file parser
# The motivation is to create a simple way to load delimited text files into ActiveRecord models`.

require 'rubygems'
require 'delimited_file'
require 'active_record'


# This is the main harness class that will do the work.
class ARImporter
  # Options are:
  # * table_name - what table you want to load data into.  Defaults to the name of the file without the extension.
  # * file_name - path to the file you want to load
  # * parser - a PipeDelimited parser to parse the data, defaults to nil.  If nil, a new parser will be constructed using the defaults
  # * progress - defaults to report every 250 rows loaded, if set to 0 progress results will be omitted.
  # 
  # Connection options are valid options for an ActiveRecord connection for example:
  # * adapter - ActiveRecord adapter type, no default
  # * host    - The host you are connecting to, no default
  # * database - The database you want to work with, no default
  def initialize(options = {}, connection_parameters = {})
    @connection_parameters = connection_parameters
    merge_options options
    establish_connection
    table_name
    set_base_table
    @rows_loaded = 0
    @rows_error = 0
  end
  
  attr_accessor :options
  attr_reader :rows_loaded, :rows_error
  
  # Merges supplied options with the default options
  def merge_options(options)
    @options = {
      :table_name => nil,
      :progress   =>  500
    }.merge(options)
  end

  # Establish a connection to the database using the supplied configuration
  # :adapter  => 'mysql',
  # :host     => 'localhost',
  # :database => 'my_database'

  def establish_connection
    ActiveRecord::Base.establish_connection(@connection_parameters)
    # this require must come after establishing the base connection
    # otherwise it will throw errors
    require 'ar-extensions'
  end
  
  # If no table name is supplied, use the name of the file for the table name
  def table_name
    if @options[:table_name].nil?
      fn = @options[:file_name]
      @options[:table_name] = File.basename(fn).gsub(File.extname(fn), '')
    end
    @options[:table_name]
  end
  
  # Load the data into the table.
  # This method makes use of the PipeDelimited parser with the default options
  # if you need to specify something other than the default options pass a populated
  # PipeDelimited object in the options has as :parser.
  def load_data
    set_base_table
    print "#{table_name}"
    progress = @options[:progress]

    pd = nil
    if @options[:parser] == nil
      df = DelimitedFile.new(@options[:file_name])
    else
      df = @options[:parser]
    end
    
    columns = []
    values = []
    eof = false
    
    while not eof
        # pd.each_with_index do |row, index|
      begin
        values << delete_blanks(df.raw_line)
        columns = df.header_cols if @rows_loaded == 0
        # load = eval "#{loader_name}.new"     
        # load = Loader.new(row)
        # load.attributes = row
        # models << load
        # load.save!
        @rows_loaded += 1
        
        if progress > 0 && (@rows_loaded % progress) == 0
          eval "#{loader_name}.import(columns, values) "
          values = []
          print "."
          
          puts " #{@rows_loaded}" if progress > 0 && (@rows_loaded % 20_000) == 0
          $stdout.flush
        end

        unless values == []
          eval "#{loader_name}.import(columns, values)"
          values = []
        end

      rescue EOFError
        eof = true
      rescue Exception => ex
        
        @rows_error += 1
        puts "Error saving line #{@rows_loaded}"
        p "Error Info: #{ex}"
      end # begin / rescue
    end # pd.each_with_index
    puts " #{@rows_loaded}"
  end
  
  def delete_blanks(row)
    row.collect {|item| item == '' ? nil : item}
  end
  
  def database_rows
    eval "#{loader_name}.count(:all)"
  end
  
  # dynamically bind Loader to the table_name we are loading data for.
  def set_base_table
    mystr = <<-EOL
    class #{loader_name} < ActiveRecord::Base
      set_table_name '#{table_name}'
    end

    # Avoid problems with STI and exporting data
    #{loader_name}.inheritance_column = nil
    EOL
    
    eval(mystr)
  end
  
  def loader_name
    "Loader_#{table_name}"
  end
  
end