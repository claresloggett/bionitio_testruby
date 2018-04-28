require File.expand_path("../lib/bionitio_testruby/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'bionitio_testruby'
  s.version     = Bionitio_testruby::VERSION
  s.summary     = "Summarise FASTA files"
  s.description = "The program reads one or more input FASTA files. For each file it computes a
variety of statistics, and then prints a summary of the statistics as output."
  s.authors     = ["David Powell"]
  s.email       = 'david@drp.id.au'
  s.files       = ["lib/bionitio_testruby.rb","lib/bionitio_testruby/version.rb"]
  s.executables = ["bionitio_testruby"]
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/bionitio_testruby-team/bionitio_testruby'

  s.add_dependency 'bio', '~> 1.5'
end
