Gem::Specification.new do |s|

  s.name        = "rack_replace"
  s.version     = '0.0.4'
  s.authors     = ['Eric Anderson']
  s.email       = ['eric@pixelwareinc.com']

  s.add_dependency 'rack'
  s.add_development_dependency 'rake'

  s.files = Dir['lib/**/*.rb']
  s.has_rdoc = true
  s.extra_rdoc_files << 'README.rdoc'
  s.rdoc_options << '--main' << 'README.rdoc'

  s.summary     = 'A rack module to do find/replace on the content'
  s.description = <<DESCRIPTION
Installs a find/replace on the response from any rack application. Is
applied to each chunk being returned so it is friendly to streamed
content.
DESCRIPTION

end
