module JSONdb

  class Record

    include JSONdb::Validations::Types
    include JSONdb::Logger

    attr_reader :table_name

    def initialize(table_name, record = nil)
      @table_name = table_name
      if record.nil?
        @record = Hash.new
        @new_record = true
        @persisted = false
        JSONdb.fields[@table_name].to_hash.keys.each do |name|
          # if JSONdb::Validations::Records::FieldsToNotVerify.include?(name) == false
            if JSONdb.fields[@table_name][name].default.nil? == false
              @record[name] = JSONdb.fields[@table_name][name].default
            end
          # end
        end
      else
        @new_record = false
        @persisted = true
        @record = record
      end
    end

    def fields
      JSONdb.fields[@table_name].to_hash.keys
    end

    def to_hash
      @record
    end

    def set_default_if_nil(name)
      if @record[name].nil?
        @record[name] = JSONdb.fields[@table_name][name].default if JSONdb.fields[@table_name][name].default.nil? == false
      end
      return @record[name]
    end

    def data_from_hash(hash)
      hash.each do |key, value|
        @record[key] = value
      end
    end

    def created_at
      Time.at(@record['created_at'])
    end

    def updated_at
      Time.at(@record['updated_at'])
    end

    def method_missing(name, *args)
      name = name.to_s
      field_name = name.sub('=', '')

      if JSONdb.fields[table_name].to_hash.keys.include?(name.sub('=', ''))
        if name =~ /=$/
          if @record[name] != args[0]
            if validate_type(JSONdb.fields[@table_name][field_name].type, args[0])
              @record[name.sub('=', '')] = args[0]
            end
          end
        else
          set_default_if_nil(name) # returns default value if value(name) is nil
        end
      else
        log("Column '#{field_name}' do not exists", :error)
      end
    end

  end

end
