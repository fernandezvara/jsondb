module JSONdb

    module Tables 

    include JSONdb::Logger

    def table(name)
      begin
        return JSONdb.tables[name]
      rescue
        log("Table does not exists '#{name}'.", :error)
        return nil
      end
    end

    def tables
      JSONdb.tables
    end

    def table_names
      JSONdb.tables.keys
    end

    def table_count
      return table_names.count
    end

    def table_exists?(name)
      JSONdb.tables.keys.include?(name)
    end

    def load_table(name)
      begin
        JSONdb.tables[name] = JSONdb::Table.new(name, false)
        log("Loaded from disk '#{name}',", :info)
        return true
      rescue
        log("Cannot load from disk '#{name}'", :error)
        return false
      end
    end

    def create_table(name)
      if table_exists?(name)
        log("Already exists '#{name}'.", :error)
        return false
      else
        begin
          JSONdb.tables[name] = JSONdb::Table.new(name, true) 
          log("Created '#{name}'.", :info)
          return true
        rescue
          log("Cannot create '#{name}'", :error)
          return false
        end
      end
    end

    def drop_table(name)
      begin
        JSONdb.tables[name].destroy
        JSONdb.tables[name] = nil
        JSONdb.tables.delete(name)
        log("Deleted '#{name}'.", :info)
        return true
      rescue
        log("Could not delete '#{name}'.", :error)
        return false
      end
    end

    def tables_to_hash
      to_hash = Hash.new
      JSONdb.tables.each do |key, values|
        to_hash = to_hash.merge(values.to_hash)
      end
      return to_hash
    end

  end

end