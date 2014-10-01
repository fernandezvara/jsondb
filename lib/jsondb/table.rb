module JSONdb
	class Table

		attr_accessor :updated_at
		attr_reader :fields, :records, :last_id, :persisted

		include Validation

		def initialize(name, folder, updated_at, writeable)
			allowed_name?(name)
			
			@name = name
			@folder = folder
			@writeable = writeable

			@structure_file = FileOps.new(@folder, "#{@name}_structure.json", 'table_structure', @writeable)
			@records_file   = FileOps.new(@folder, "#{@name}_records.json", 'table_records', @writeable)

			# last_id
			@last_id = @structure_file.contents["last_id"]

			# Fields
			@fields = Hash.new

			if @structure_file.contents["fields"].keys.count
				@structure_file.contents["fields"].each do |name, field|
					@fields[name] ||= Field.new(name)
				end
			end
			# add id and timestamps fields if not exists...
			add_main_fields 

			# Fills records hash
			@records_contents = @records_file.contents || {}
			@records = Hash.new
			@records_contents.each do |id, record|
				@records[id] = Record.new(@fields, record)
			end

			@updated_at = Time.now.to_i if @structure_file.new_file
			@persisted = !@structure_file.new_file

		end

		def field(name)
			return @fields[name] ||= Field.new(@name)
		end

		def records
			return @records
		end

		def new_record
			@persisted = false
			@updated_at = Time.now.to_i
			return Record.new(@fields)
		end

		def query(array_fields = nil)
			return select(array_fields)
		end

		def select(array_fields = nil)
			return ResultSet.new(self, array_fields)
		end

		def insert(record)
			if record.id != 0
				raise "Record already exists."
			else
				id = new_id
				record.save_with_id(id)
				@records[id] = record
				@persisted = false
				return id
			end
		end

		def update(record)
			@persisted = false
			@records[record.id] = record.update
		end

		def delete(record)
			@persisted = false
			@records.delete(record.id)
		end

		def drop
			@structure_file.destroy
			@records_file.destroy
		end

		def persist
			@structure_file.contents['last_id'] = @last_id
			@fields.each do |id, field|
				@structure_file.contents['fields'][id] = field.to_hash
			end
			@structure_file.save

			@records_file.contents = {}
			@records.each do |id, record|
				@records_file.contents[id] = record.to_hash
			end
			@records_file.save
			@updated_at = Time.now.to_i
			@persisted = true
		end

		def to_hash
			return { "name" => @name, "updated_at" => @updated_at }
		end

		def updated_at_time
			Time.at(@updated_at)
		end

		private

		def new_id
			@last_id = @last_id + 1
			return @last_id
		end

		def add_main_fields
			if @fields["id"].nil?
				id_field = self.field('id')
				id_field.type 				= "Fixnum"
				id_field.nullable 		= false
				id_field.default 		= 0
			end
			if @fields["created_at"].nil?
				created_field = self.field('created_at')
				created_field.type 				= "Fixnum"
				created_field.nullable 		= false
				created_field.default 		= 0
			end
			if @fields["updated_at"].nil?
				updated_field = self.field('updated_at')
				updated_field.type 				= "Fixnum"
				updated_field.nullable 		= false
				updated_field.default 		= 0
			end
		end

	end
end