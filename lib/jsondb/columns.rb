class Fields

	attr_reader :table_name, :raw_data, :fields

	def initialize(table_name, raw_data)
		@fields = Hash.new
		@table_name = table_name
		@raw_data = JSON.parse(raw_data)
		@raw_data.each do |column_name, values|
			@fields[column_name] = Column.new(column_name)
			@fields[column_name].type			= values['type'] 			if values['type']
			@fields[column_name].default 	= values['default'] 	if values['default']
			@fields[column_name].nullable 	= values['nullable'] 	if values['nullable']
		end
	end

	def add(name)
		#TODO: Validate
		if @fields.keys.include?(name)
			raise "Table: Column '#{name} already exists"
		else
			@fields[name] = Column.new(name)
			return @fields[name]
		end
	end

	def remove(name)
		if @fields.keys.include?(name)
			@fields[name] = nil 
		else
			raise "Table: Column: Column '#{name}' do not exists"
		end
	end

	def column(name)
		@fields[name] ||= Column.new(name)
		return @fields[name]
	end

	def to_hash
		data = Hash.new
		@fields.each do |name, column|
			data[name] = column.to_hash
		end
		data
	end
end