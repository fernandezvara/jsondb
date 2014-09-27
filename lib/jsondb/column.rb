class Column

	include Validation

	attr_reader :name, :type, :nullable, :default

	def initialize(name)
		@name = name
		@nullable = true
	end

	def type=(_class)
		@type = allowed?(_class)
	end

	def type
		@type
	end

	def nullable=(value)
		@nullable = validate_type("Bool", value)
	end

	def nullable
		@nullable
	end

	def default=(value)
		@default = validate_type(@type, value)
	end

	def default
		@default
	end

	def to_hash
		data = Hash.new
		data['type']			= @type
		data['nullable']	= @nullable
		data['default']		= @default
		data
	end
end