#db.rb
class Db

	attr_reader :folder, :tables

	def initialize(root)
		# root = folder where files resides
		if Dir.exists?(File.expand_path(root))
			@folder = File.expand_path(root)
		else
			raise "Folder '#{root}' do not exists."
		end

		@tables = Hash.new

		load_structure
		
	end
	
	def table(name)
		@tables[name] ||= Table.new(name)
	end

	def table_add(name)
		@tables[name] = Table.new(name)
	end

	def table_names
		@tables.keys
	end

	private 

	def load_structure
		@file = File.open(File.join(@folder, '_db.json'), 'w+')
		@raw = @file.read
		if @raw == ""
			@raw = '{ "tables": [] }'
		end
		@contents = JSON.parse(@raw)
	end

	def save_structure
		@file.write(JSON.generate(@contents))
	end
end