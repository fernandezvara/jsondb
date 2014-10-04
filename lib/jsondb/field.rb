module JSONdb

  class Field

    include JSONdb::Validations::Naming
    include JSONdb::Validations::Types
    include JSONdb::Logger

    #attr_accessor :type, :nullable, :default

    def initialize(name)
      @name = name if allowed_name?(name)

      # override common setters
      self.type       = "String"
      self.nullable   = true
      self.default    = nil

      # set_defaults
    end

    def type=(_class)
      if allowed_type?(_class)
        @type = _class  
        return true
      else
        log("'#{_class}' not allowed as field type", :error)
        return false
      end
    end

    def nullable=(value)
      if validate_type("Bool", value)
        @nullable = value
        return true
      else
        log("'#{value}' not allowed for nullable", :error)
        return false
      end
    end

    def default=(value)
      if validate_type(@type, value)
        @default = value
        return true
      else
        log("'#{value}' not allowed as #{type} class.")
        return false
      end
    end

    def nullable
      @nullable
    end

    def type
      @type
    end

    def default
      @default
    end

    def to_hash
      {
        "type"      => @type,
        "nullable"  => @nullable,
        "default"   => @default
      }
    end

    private

    def set_defaults
      @nullable   = true
      @default    = nil
      @type       = "String"
    end

  end

end