module JSONdb

  class Db

    attr_reader :created_at, :updated_at, :folder

    include JSONdb::Tables
    include JSONdb::Commands

    def initialize(folder, create_folder_if_not_exists = true, writeable = true)

      JSONdb.settings.folder        = folder
      JSONdb.settings.log_folder    = folder
      JSONdb.settings.writeable     = writeable

      @folder = File.expand_path(folder)
      @created_at = nil
      @updated_at = nil

      open_database(create_folder_if_not_exists)
    end

    def writable
      JSONdb.settings.writeable
    end

    def persist
      begin
        JSONdb.tables.keys.each do |key|
          JSONdb.tables[key].persist if JSONdb.tables[key].persisted == false
        end
        @file.contents = db_to_hash(true)
        @file.write
        log("DB saved to disk", :debug)
        return true
      rescue
        log("DB NOT saved to disk!", :error, true)
        return false
      end
    end

    def db_to_hash(update = false)
      @updated_at = Time.now.to_i if update
      {
        "tables" => tables_to_hash,
        "db" => {
          "created_at" => @created_at,
          "updated_at" => @updated_at
        }
      }
    end

    private

    def open_database(create_folder_if_not_exists)
      create_folder if create_folder_if_not_exists == true

      raise "DB Main Folder not found!" if !Dir.exists?(@folder)

      @file = FileOps.new(@folder, '_db.json', 'db')
      @file.read
      tables_in_file = @file.contents['tables']
      
      tables_in_file.each do |table_name, values|
        JSONdb.tables[table_name] = JSONdb::Table.new(table_name, false)
        JSONdb.tables[table_name].created_at = values['created_at']
        JSONdb.tables[table_name].updated_at = values['updated_at']
        JSONdb.tables[table_name].last_id    = values['last_id']
        JSONdb.fields[table_name] = Hash.new
        # fields
        fields_in_file = values['fields']
        fields_in_file.each do |field_name, field_values|
          JSONdb.fields[table_name][field_name] = Field.new(field_name) 
          JSONdb.fields[table_name][field_name].type      = field_values['type']  
          JSONdb.fields[table_name][field_name].nullable = field_values['nullable']
          JSONdb.fields[table_name][field_name].default   = field_values['default']
        end
      end

      if @file.new_file
        @file.write
        log("Created data file for database structure.", :info)
      else
        log("Loaded data file for database structure.", :info)
      end
    end

    def create_folder
      @created_at = Time.now.to_i
      FileUtils.mkdir_p(@folder) if !Dir.exists?(@folder)
    end

  end #class

end #module