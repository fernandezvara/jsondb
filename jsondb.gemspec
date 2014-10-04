Gem::Specification.new do |s|
  s.name        = 'jsondb'
  s.version     = '0.1.3'
  s.date        = '2014-10-02'
  s.summary     = "lib to manage tiny databases in plain JSON files"
  s.description = "Local Database using JSON files"
  s.authors     = ["Antonio Fernandez"]
  s.email       = 'antoniofernandezvara@gmail.com'
  s.files       = [
    "lib/jsondb.rb",
    "lib/jsondb/base.rb",
    "lib/jsondb/commands.rb",
    "lib/jsondb/constants.rb",
    "lib/jsondb/db.rb",
    "lib/jsondb/field.rb",
    "lib/jsondb/fields.rb",
    "lib/jsondb/file_ops.rb",
    "lib/jsondb/logger.rb",
    "lib/jsondb/record.rb",
    "lib/jsondb/records.rb",
    "lib/jsondb/result_set.rb",
    "lib/jsondb/settings.rb",
    "lib/jsondb/table.rb",
    "lib/jsondb/tables.rb",
    "lib/jsondb/validations.rb",
  ]
  s.homepage    = 'http://fernandezvara.github.io/jsondb/'
  s.license     = 'MIT'
  s.add_runtime_dependency 'json_pure', '= 1.8.1'
end