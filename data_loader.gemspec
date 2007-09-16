# dataloader.gemspec
require 'rubygems'
spec = Gem::Specification.new do |spec|
  spec.name = 'data_loader'
  spec.summary = 'Simple data loader for ActiveRecord using PipeDelimited parser'
  spec.description = %{A fast simple data loaded designed to work with ActiveRecord using the 
      PipeDelimited parser gem.
  }
  spec.author = 'Doug Tolton'
  spec.email = 'data_loader.closure@recursor.net'
  spec.test_files = Dir['test/*']
  spec.has_rdoc = true
  spec.files = Dir['lib/*.rb'] + spec.test_files
  spec.version = '0.1.2'
  spec.add_dependency('piped')
  spec.add_dependency('activerecord', '~> 1')
end