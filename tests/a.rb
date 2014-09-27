class Table

	attr_reader :attributes, :columns, :last_id

	def initialize
		@attributes = {}
		@columns = Columns.new()
		@last_id = 0
		@registries = Array.new
	end

	
end

class Registry

	def initialize(columns)
		@columns = columns
	end

	def method_missing(name, *args)
		attribute = name.to_s

		if @columns.keys.include?(attribute.sub('=', ''))
			if attribute =~ /=$/			
				@attributes[attribute.sub('=', '')] = args[0]
			else
				@attributes[attribute]
			end
		else
			raise "Column '#{attribute.sub('=', '')}' do not exists"
		end
	end
end

class Columns

	attr_reader :table_name, :raw_data, :columns

	def initialize(table_name, raw_data)
		@columns = Hash.new
		@table_name = table_name
		@raw_data = JSON.parse(raw_data)
		@raw_data.each do |column_name, values|
			@columns[column_name] = Column.new(column_name)
			@columns[column_name]['type'] 			= values['type'] 			if values['type']
			@columns[column_name]['default'] 		= values['default'] 	if values['default']
			@columns[column_name]['nullable'] 	= values['nullable'] 	if values['nullable']
		end
	end

	def add(name)
		#TODO: Validate
		if @columns.keys.include?(name)
			raise "Table: Column '#{name} already exists"
		else
			@columns[name] = Column.new(name)
			return @columns(name)
		end
	end

	def remove(name)
		if @columns.keys.include?(name)
			@columns[name] = nil 
		else
			raise "Table: Column: Column '#{name}' do not exists"
		end
	end
end

class Column

	include Validation

	attr_reader :name

	def initialize(name)
		@data = Hash.new
		@data[name] = Hash.new
		@name = name
	end

	def type=(_class)
		@data[@name]['type'] = allowed?(_class)
	end

	def type
		@data[@name]['type']
	end

	def nullable=(value)
		@data[@name]['nullable'] = validate_type("Bool", value)
	end

	def nullable
		@data[@name]['nullable']
	end

	def default=(value)
		@data[@name]['default'] = validate_type(@data[@name]['type'], value)
	end

	def default
		@data[@name]['default']
	end
end

module Validation

	def allowed_types
		["String", "Integer", "Float", "Date", "Bool"]
	end

	def allowed?(type)
		if allowed_types.include?(type.to_s)
			return type.to_s
		else
			raise "Validation: Type '#{type.to_s}' not allowed"
		end
	end

	def validate_type(_class, _value)
		#_class = eval(_class) if _class.class.to_s == "String"
		case _class
		when "Bool"
			case _value
			when true, false
				return value
			else
				raise "Validation: Bool: Not a Bool type"
			end
		when "String", "Integer", "Float"
			if _value.class.to_s == _value
				return _value
			else
				raise "Validation: #{_class}: Value not allowed for '#{_class}' type"
			end
		when "Integer", "Float"
			case _class
			when "Integer"
				if eval(_value).class.to_s == "Integer"
					return _value
				else
					raise "Validation: '#{_value}' is not Integer"
				end
			when "Float"
				case eval(_value).class.to_s
				when "Float"
					return _value
				when "Integer"
					return _value.to_f
				end
			else
				raise "Validation: '#{_value} is not a Numeric type"
			end
		else
			raise "Validation: '#{_class}' type not allowed"
		end
	end
end

a = A.new
a.columns = ['col1', 'col2']

a.col1 = "vanilla"
puts a.col1
puts a.col2
puts a.col3