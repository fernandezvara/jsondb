module Validation

	def allowed_types
		["String", "Fixnum", "Integer", "Float", "Date", "Bool"]
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
				return _value
			else
				raise "Validation: Bool: Not a Bool type"
			end
		when "String"
			if _class == _value.class.to_s
				return _value
			else
				raise "Validation: #{_class}: Value '#{_value}' not allowed for '#{_class}' type"
			end
		when "Fixnum", "Integer", "Float"
			case _class
			when "Integer"
				if eval(_value).class.to_s == "Integer"
					return _value
				else
					raise "Validation: '#{_value}' is not Integer"
				end
      when "Fixnum"
        if _value.class.to_s == "Fixnum"
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