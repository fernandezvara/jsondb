class Columns

	attr_reader :table_name, :raw_data, :columns

	def initialize(table_name, raw_data)
		@columns = Hash.new
		@table_name = table_name
		@raw_data = JSON.parse(raw_data)
		@raw_data.each do |column_name, values|
			@columns[column_name] = Column.new(column_name)
			@columns[column_name].type			= values['type'] 			if values['type']
			@columns[column_name].default 	= values['default'] 	if values['default']
			@columns[column_name].nullable 	= values['nullable'] 	if values['nullable']
		end
	end

	def add(name)
		#TODO: Validate
		if @columns.keys.include?(name)
			raise "Table: Column '#{name} already exists"
		else
			@columns[name] = Column.new(name)
			return @columns[name]
		end
	end

	def remove(name)
		if @columns.keys.include?(name)
			@columns[name] = nil 
		else
			raise "Table: Column: Column '#{name}' do not exists"
		end
	end

	def column(name)
		@columns[name] ||= Column.new(name)
		return @columns[name]
	end

	def to_hash
		data = Hash.new
		@columns.each do |name, column|
			data[name] = column.to_hash
		end
		data
	end
end