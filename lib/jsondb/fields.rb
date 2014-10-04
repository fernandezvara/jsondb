module JSONdb

  module Fields

    def fields
      JSONdb.fields[@name].keys
    end

    def field(name)
      JSONdb.fields[@name][name]
    end

    def create_field(name)
      JSONdb.fields[@name][name] = Field.new(name)
    end

    def drop_field(name)
      JSONdb.fields[@name][name] = nil
      JSONdb.fields[@name].delete(name)
    end

    def fields_to_hash
      to_hash = Hash.new
      JSONdb.fields[@name].each do |key, values|
        to_hash.merge!({
          key => values.to_hash
        })
      end
      return to_hash
    end

    def add_main_fields
      if JSONdb.fields[@name]["id"].nil?
        JSONdb.fields[@name]["id"] = create_field('id')
        JSONdb.fields[@name]["id"].type         = "Fixnum"
        JSONdb.fields[@name]["id"].nullable     = false
        JSONdb.fields[@name]["id"].default      = 0
      end
      if JSONdb.fields[@name]["created_at"].nil?
        JSONdb.fields[@name]["created_at"] = create_field('created_at')
        JSONdb.fields[@name]["created_at"].type        = "Fixnum"
        JSONdb.fields[@name]["created_at"].nullable    = false
        JSONdb.fields[@name]["created_at"].default     = 0
      end
      if JSONdb.fields[@name]["updated_at"].nil?
        JSONdb.fields[@name]["updated_at"] = create_field('updated_at')
        JSONdb.fields[@name]["updated_at"].type        = "Fixnum"
        JSONdb.fields[@name]["updated_at"].nullable    = false
        JSONdb.fields[@name]["updated_at"].default     = 0
      end
    end

  end

end