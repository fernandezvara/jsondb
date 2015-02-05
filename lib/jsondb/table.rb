module JSONdb

  class Table

    include JSONdb::Validations::Naming
    include JSONdb::Logger
    include JSONdb::Fields
    include JSONdb::Records

    attr_reader  :persisted, :name
    attr_accessor :timestamp, :created_at, :updated_at, :last_id

    def initialize(name, new_table = true)
      @name = name
      
      @persisted = false

      JSONdb.records[@name] = JSONdb::PaginatedHash.new 
      JSONdb.fields[@name] = Hash.new

      set_defaults
      add_main_fields
      init_table(new_table)
    end

    def persist
      @persisted = true
      @file.contents = records_to_hash
      @file.write
    end

    def to_hash
      {
        @name => {
          "created_at" => @created_at,
          "updated_at" => @updated_at,
          "last_id" => @last_id,
          "fields" => fields_to_hash
        },
      }
    end

    def destroy
      @file.destroy
    end

    def created_at
      Time.at(@created_at)
    end

    def updated_at
      Time.at(@updated_at)
    end

    private

    def new_id
      @last_id = @last_id + 1
      return @last_id
    end

    def set_defaults
      @created_at     = Time.now.to_i
      @updated_at     = Time.now.to_i

      @timestamp      = true
      @id_autonumber  = true
      @last_id        = 0
    end

    def init_table(new_table)
      begin
        if allowed_name?(@name)
          @file = FileOps.new(JSONdb.settings.folder, "#{@name}.json", 'table', true)
          @file.read

          records_in_file = @file.contents
      
          # JSONdb.records[@name] = Hash.new
          records_in_file.each do |key, values|
            JSONdb.records[@name][values['id']] = Record.new(@name, values)
          end

          if new_table
            @file.write
            @persisted = true
            log("Created data file for '#{@name}'.", :info)
          else
            @persisted = true
            log("Loaded data file for '#{@name}'.", :info)
          end
        else
          log("Could not initialize class for table '#{@name}'.", :error)
        end
      rescue
        log("Could not initialize class for table '#{@name}'.", :error)
      end
    end


  end

end