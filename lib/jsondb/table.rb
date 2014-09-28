class Table

	attr_reader :fields, :last_id

	def initialize(name)
		@name = name
		@fields = Fields.new(@name, "{}")
		add_main_fields
		@last_id = 0
		@records = Hash.new
	end

	# def fields_to_hash
	# 	fields = Hash.new
	# 	@fields.to_hash.each do |k, v|
	# 		fields = fields.merge(v.to_hash)
	# 	end
	# 	fields
	# end

	def field(name)
		return @fields.field(name)
	end

	def records
		return @records
	end

	def new_record
		Record.new(@fields.to_hash)
	end

	def query(array_fields = nil)
		return select(array_fields)
	end

	def select(array_fields = nil)
		return ResultSet.new(self.records, self.fields.to_hash, array_fields)
	end

	def insert(record)
		id = new_id
		record.save_with_id(id)
		@records[id] = record
		return id
	end

	def update(record)
		return record.update
	end

	def delete(record)
		@records.delete(record.id)
	end

	def persist
		# TODO: File operations
		return true
	end

	private

	def new_id
		@last_id = @last_id + 1
		return @last_id
	end

	def add_main_fields
		id_field = self.field('id')
		id_field.type 				= "Fixnum"
		id_field.nullable 		= false
		id_field.default 		= 0
		created_field = self.field('created_at')
		created_field.type 				= "Fixnum"
		created_field.nullable 		= false
		created_field.default 		= 0
		updated_field = self.field('updated_at')
		updated_field.type 				= "Fixnum"
		updated_field.nullable 		= false
		updated_field.default 		= 0
	end
end