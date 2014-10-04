module JSONdb

  module Validations

    module Naming

      include JSONdb::Logger
      
      def allowed_name?(name)
        if (name =~ /^[a-zA-Z0-9_]+$/).nil?
          log("Name '#{name}' not allowed. /^[a-zA-Z0-9_]+$/", :error)
          return false
        else
          return true
        end
      end
    end

    module Types

      include JSONdb::Logger

      AllowedTypes = [
        "String", 
        "Fixnum", 
        "Integer", 
        "Float", 
        "Time", 
        "Bool"
      ]

      def allowed_type?(type)
        if AllowedTypes.include?(type.to_s)
          return true
        else
          log("Validation: Type '#{type.to_s}' not allowed", :error)
          return false
        end
      end

      def validate_type(_class, _value)
        return true if _value.nil?

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
          log("Validation: '#{_class}' type not allowed", :error)
          return false
        end
      end

      private
      
      def bool?(_class, _value)
        case _value
        when true, false
          return true
        else
          log("Validation: Bool: Not a Bool type", :error)
          return false
        end
      end

      def string?(_class, _value)
        if _class == _value.class.to_s
          return true
        else
          log("Validation: #{_class}: Value '#{_value}' not allowed for '#{_class}' type", :error)
          return false
        end
      end

      def numeric?(_class, _value)
        case _class
        when "Fixnum", "Integer"
          if _value.class.to_s == "Fixnum"
            return true
          else
            log("Validation: '#{_value}' is not Integer", :error)
            return false
          end
        when "Float"
          case _value.class.to_s
          when "Float"
            return true
          when "Fixnum"
            return true
          else
            log("Validation: '#{_value} is not a Float type", :error)
          end
        else
          log("Validation: '#{_value} is not a Numeric type", :error)
          return false
        end
      end

      def time?(_class, _value)
        if eval(_value).class.to_s == "Time"
          return true
        else
          log("Validation: '#{_value} is not a Time type", :error)
          return false
        end
      end
    end # Types

    module Records

      include JSONdb::Validations::Types

      FieldsToNotVerify = ['id', 'created_at', 'updated_at']

      def record_validates?(table_name, record)
        table_fields = JSONdb.fields[table_name]
        table_fields.each do |field_name, field_values|
          if FieldsToNotVerify.include?(field_name) == false
            actual_value = record.send field_name.to_sym
            return false if field_values.nullable == false and actual_value.nil?
            return false if validate_type(field_values.type, actual_value) == false
          end
        end
        return true # true if no previous invalidation
      end

    end

  end # Validations
end # JSONdb