module JSONdb
  
  module Commands

    include JSONdb::Validations::Records

    def select_from(table_name)
      return ResultSet.new(table_name)
    end

    alias :select :select_from

    def insert_into(table_name, record)
      if record_validates?(table_name, record)
        JSONdb.tables[table_name].insert_record(record)
        log("Inserted record: #{record.inspect}", :debug)
        return true
      else
        log("Record do not pass validations: #{record.inspect}", :error)
        return false
      end
    end

    alias :insert :insert_into

    def update_set(table_name, record)
      if record_validates?(table_name, record)
        JSONdb.tables[table_name].update_record(record)
        log("Inserted record: #{record.inspect}", :debug)
        return true
      else
        log("Record do not pass validations: #{record.inspect}", :error)
        return false
      end
    end

    alias :update :update_set

    def delete(table_name, record)
      if JSONdb.tables[table_name].exists?(record)
        log("Deleting record: #{record.inspect}", :debug)
        JSONdb.tables[table_name].drop_record(record)
        return true
      else
        log("Record does not exists, so we can delete it", :error)
        return false
      end
    end

    def delete_by_id(table_name, id)
      return delete(table_name, JSONdb.records[table_name][id])
    end

  end

end