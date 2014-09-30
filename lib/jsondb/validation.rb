module Validation

	def allowed_types
		["String", "Fixnum", "Integer", "Float", "Time", "Bool"]
	end

	def allowed_name?(name)
		if (name =~ /^[a-zA-Z0-9_]+$/).nil?
			raise "Name not allowed. /^[a-zA-Z0-9_]+$/"
		else
			return true
		end
	end

	def allowed?(type)
		if allowed_types.include?(type.to_s)
			return type.to_s
		else
			raise "Validation: Type '#{type.to_s}' not allowed"
		end
	end

	def validate_type(_class, _value)
		case _class
		when "Bool"
			bool?(_class, _value)
		when "String"
			string?(_class, _value)
		when "Fixnum", "Integer", "Float"
			numeric?(_class, _value)
		when "Time"
			time?(_class, _value)
		else
			raise "Validation: '#{_class}' type not allowed"
		end
	end

	private
	
	def bool?(_class, _value)
		case _value
		when true, false
			return _value
		else
			raise "Validation: Bool: Not a Bool type"
		end
	end

	def string?(_class, _value)
		if _class == _value.class.to_s
			return _value
		else
			raise "Validation: #{_class}: Value '#{_value}' not allowed for '#{_class}' type"
		end
	end

	def numeric?(_class, _value)
		case _class
	  when "Fixnum", "Integer"
	    if _value.class.to_s == "Fixnum"
	      return _value
	    else
	      raise "Validation: '#{_value}' is not Integer"
	    end
		when "Float"
			case eval(_value).class.to_s
			when "Float"
				return _value
			when "Fixnum"
				return _value.to_f
			else
				raise "Validation: '#{_value} is not a Float type"	
			end
		else
			raise "Validation: '#{_value} is not a Numeric type"
		end
	end

	def time?(_class, _value)
		if eval(_value).class.to_s != "Time"
			raise "Validation: '#{_value} is not a Time type" 
		end
	end
	
end

