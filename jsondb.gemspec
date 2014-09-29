Gem::Specification.new do |s|
  s.name        = 'jsondb'
  s.version     = '0.0.1'
  s.date        = '2014-09-25'
  s.summary     = "Database in plain JSON files"
  s.description = "Local Database using JSON files"
  s.authors     = ["Antonio Fernandez"]
  s.email       = 'antoniofernandezvara@gmail.com'
  s.files       = [
    "lib/jsondb.rb",
    "lib/jsondb/db.rb",
    "lib/jsondb/validation.rb",
    "lib/jsondb/table.rb",
    "lib/jsondb/fields.rb",
    "lib/jsondb/field.rb",
    "lib/jsondb/record.rb",
    "lib/jsondb/resultset.rb"
  ]
  s.homepage    = 'http://jsondb.'
  s.license     = 'MIT'
  s.add_runtime_dependency 'json_pure', '= 1.8.1'
end