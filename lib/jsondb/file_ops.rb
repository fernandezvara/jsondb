module JSONdb
  class FileOps

    attr_reader :writeable, :filename, :folder, :raw, :new_file

    def initialize(folder, filename, filetype, writeable = true)
      @folder = folder
      @writeable = writeable
      @filename = File.join(@folder, filename)
      @filetype = filetype
      if exists?(@folder)
        load 
      else
        raise "Folder '#{@folder}' does not exists."
      end
    end

    def contents=(contents)
      @contents = contents
    end

    def contents
      @contents
    end

    def save
      return false if @writeable == false
      @file = File.open(@filename, 'w')
      @raw = JSON.pretty_generate(@contents)
      @file.write(@raw)
      @file.close
      @new_file = false
      return true
    end

    def destroy
      File.delete(@filename) if exists?(@filename)
    end

    def close
      @file.close if @file
    end

    private

    def exists?(file)
      File.exists?(File.expand_path(file))
    end

    def load
      @new_file = !exists?(@filename)
      if exists?(@filename)
        @file = File.open(@filename, 'r') 
        @raw = @file.read
      else
        @raw = default_content
      end
      @contents = JSON.parse(@raw)
      @file.close if @file
    end

    def default_content
      case @filetype
      when 'db'
        '{ "tables": {} }'
      when 'table_structure'
        '{ "last_id" : 0, "fields": {} }'
      when 'table_records'
        '{ }'
      end
    end
  end
end