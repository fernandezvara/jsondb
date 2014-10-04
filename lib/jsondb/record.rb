module JSONdb

  class Record

    include JSONdb::Validations::Types
    include JSONdb::Logger

    attr_reader :table_name

    def initialize(table_name, record = nil)
      @record = Hash.new

      @table_name = table_name
      if record.nil?
        @new_record = true
        @persisted = false
      else
        @new_record = false
        @persisted = true
        @record = record
      end
    end

    def fields
      JSONdb.fields[table_name].to_hash.keys
    end      

    def to_hash
      @record
    end

    def set_default_if_nil(name)
      if @record[name].nil?
        @record[name] = JSONdb.fields[table_name][name].default if JSONdb.fields[table_name][name].default.nil? == false
      end
      return @record[name]
    end

    def method_missing(name, *args)
      name = name.to_s

      if JSONdb.fields[table_name].to_hash.keys.include?(name.sub('=', ''))
        if name =~ /=$/
          if @record[name] != args[0]
            @record[name.sub('=', '')] = args[0]
          end
        else
          set_default_if_nil(name) # returns default value if value(name) is nil
        end
      else
        log("Column '#{name.sub('=', '')}' do not exists", :error)
      end
    end

  end

end