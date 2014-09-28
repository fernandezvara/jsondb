class Fields

	attr_reader :table_name, :raw_data, :fields

	def initialize(table_name, raw_data)
		@fields = Hash.new
		@table_name = table_name
		@raw_data = JSON.parse(raw_data)
		@raw_data.each do |column_name, values|
			@fields[column_name] = Field.new(column_name)
			@fields[column_name].type				= values['type'] 			if values['type']
			@fields[column_name].default 		= values['default'] 	if values['default']
			@fields[column_name].nullable 	= values['nullable'] 	if values['nullable']
		end
	end

	def names
		names = Array.new
		@fields.each do |n, f|
			names << n 
		end
		return names
	end

	def add(name)
		#TODO: Validate
		if @fields.keys.include?(name)
			raise "Table: Column '#{name} already exists"
		else
			@fields[name] = Field.new(name)
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

	def field(name)
		@fields[name] ||= Field.new(name)
		return @fields[name]
	end

	def to_hash
		data = Hash.new
		@fields.each do |name, field|
			data[name] = field.to_hash
		end
		data
	end
end