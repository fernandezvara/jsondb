#it depends on json_pure
require 'json/pure'

this_dir = File.dirname(__FILE__)
require File.join(this_dir, 'jsondb/file_ops')
require File.join(this_dir, 'jsondb/db')
require File.join(this_dir, 'jsondb/validation')
require File.join(this_dir, 'jsondb/table')
require File.join(this_dir, 'jsondb/field')
require File.join(this_dir, 'jsondb/record')
require File.join(this_dir, 'jsondb/resultset')