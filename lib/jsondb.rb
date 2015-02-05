#it depends on json_pure
require 'json/pure'
require 'fileutils'

this_dir = File.dirname(__FILE__)
require File.join(this_dir, 'jsondb/paginated_hash')

require File.join(this_dir, 'jsondb/constants')
require File.join(this_dir, 'jsondb/logger')
require File.join(this_dir, 'jsondb/validations')
require File.join(this_dir, 'jsondb/settings')
require File.join(this_dir, 'jsondb/file_ops')
require File.join(this_dir, 'jsondb/result_set')
require File.join(this_dir, 'jsondb/commands')
require File.join(this_dir, 'jsondb/record')
require File.join(this_dir, 'jsondb/records')
require File.join(this_dir, 'jsondb/field')
require File.join(this_dir, 'jsondb/fields')
require File.join(this_dir, 'jsondb/table')
require File.join(this_dir, 'jsondb/tables')
require File.join(this_dir, 'jsondb/db')
require File.join(this_dir, 'jsondb/base')