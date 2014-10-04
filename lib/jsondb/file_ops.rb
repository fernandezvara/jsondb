module JSONdb

  class FileOps

    include JSONdb::Logger

    attr_reader :folder, :writeable, :filename, :filetype, :new_file

    attr_accessor :contents

    def initialize(folder, filename, filetype, json = true)
      @folder = folder
      @filename = File.expand_path(File.join(@folder, filename))
      @filetype = filetype
      @contents = ""
      @json = json
    end

    def read
      begin
        if File.exists?(@filename)
          file = File.open(@filename, 'r') 
          raw = file.read
          @new_file = false
          log("File '#{@filename}' readed.", :debug)
        else
          raw = JSONdb.constants.default_file_content[@filetype]
          @new_file = true
        end
        if @json == true
          @contents = JSON.parse(raw)
        else
          @contents = raw
        end
        file.close if file
        log("File '#{@filename}' parsed.", :debug)
        return true
      rescue
        log("File '#{@filename}' could not read the file.", :error)
        return false
      end
    end

    def write
      begin
        file = File.open(@filename, 'w')
        if @json == true
          file.write(JSON.pretty_generate(@contents))
        else 
          file.write(@contents)
        end
        file.close
        @new_file = false
        log("File '#{@filename}' content updated.", :debug)
        return true
      rescue
        log("File '#{@filename}' could not open and write the file.", :error)
        return false
      end
    end

    def write_line(line)
      begin
        file = File.open(@filename, 'a+')
        file.write("#{line}\n")
        file.close
        @new_file = false
      rescue
        log("Couldn't write line on file '#{@filename}'.", :error)
      end
    end

    def destroy
      if File.exists?(@filename)
        File.delete(@filename) 
        log("File '#{@filename}' deleted.", :info)
      else
        log("File '#{@filename}' does not exists.", :error)
      end
    end

  end # class
end # module