module JSONdb

  module Records

    def record(key)
      JSONdb.records[@name][key]
    end

    def new_record
      return JSONdb::Record.new(@name)
    end

    def insert_record(record)
      @persisted = false
      @updated_at = Time.now.to_i # updated table updated_at time
      
      record.id = new_id
      record.created_at = Time.now.to_i
      record.updated_at = Time.now.to_i
      JSONdb.records[@name][record.id] = record
    end

    def update_record(record)
      @persisted = false
      JSONdb.records[@name][record.id] = record
    end

    def drop_record(record)
      begin
        @persisted = false
        JSONdb.records[@name][record.id] = nil
        JSONdb.records[@name].delete(record.id)
        record = nil
        return true
      rescue
        return false
      end
    end

    def exists?(record)
      !JSONdb.records[@name][record.id].nil?
    end

    def record_count
      JSONdb.records[@name].keys.count
    end

    alias :count :record_count

    def records_to_hash
      to_hash = Hash.new
      JSONdb.records[@name].each do |key, values|
        to_hash = to_hash.merge({
          key => values.to_hash
        })
      end
      return to_hash
    end

  end

end