class Table

	attr_reader :columns, :last_id

	def initialize(name)
		@name = name
		@columns = Columns.new(@name, "{}")
		add_id_column
		@last_id = 0
		@records = Hash.new
	end

	def column(name)
		return @columns.column(name)
	end

	def records
		return @records
	end

	def new_record
		Record.new(@columns.to_hash)
	end

	def select(array_columns = [])
		return ResultSet.new(self, array_columns)
	end

	def insert(record)
		@last_id = @last_id + 1
		record.id = @last_id
		@records[@last_id] = record
		return @last_id
	end

	def delete(record)
		@records.delete(record.id)
	end

	def persist
		# TODO: File operations
		return true
	end

	private

	def add_id_column
		id_column = self.column('id')
		id_column.type 				= "Fixnum"
		id_column.nullable 		= false
		id_column.default 		= 0
	end
end