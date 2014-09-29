#db.rb
class Db

	attr_reader :root, :tables

	def initialize(root, writeable = true)
		@root = root
		@writeable = writeable
		@file = FileOps.new(@root, '_db.json', 'db', @writeable)
		@tables_in_file = @file.contents['tables'] || Hash.new({})
		@tables = Hash.new
		@tables_in_file.each do |name, values|
			@tables[name] = Table.new(name, @root, values['updated_at'], @writeable)
		end
	end
	
	def table(name)
		@tables[name] ||= Table.new(name, @root, Time.now.to_i, @writeable)
	end

	def table_add(name)
		if @tables.keys.include?(name)
			raise "Table '#{name}' already defined."
		else
			@tables[name] = Table.new(name, @root, Time.now.to_i, @writeable)
		end
	end

	def table_drop(name)
		@tables[name].drop
		@tables.delete(name)
	end

	def table_names
		@tables.keys
	end

	def persist
		@file.contents['tables'] = {}
		@tables.each do |name, table|
			if table.persisted == false
				table.updated_at = Time.now.to_i
				table.persist if table.persisted == false
			end
			@file.contents['tables'][name] = { "name" => name, "updated_at" => table.updated_at }
		end
		return @file.save
	end

end