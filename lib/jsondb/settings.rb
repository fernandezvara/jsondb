module JSONdb

  class Settings

    include JSONdb::Logger

    attr_accessor :folder, :writeable, :raise_errors, :log_enabled, :log_level, :log_file, :log_folder, :verbose

    def initialize
      @folder           = ""
      # read-only?
      @writeable        = true
      # raise errors or return true or false
      @raise_errors     = true
      # logs
      @log_enabled      = false
      @log_level        = :info
      @log_file         = "db.log"
      @log_folder       = nil
      @verbose          = false
      # 
    end

    def log_level=(level)
      if allowed_log_level?(level)
        @log_level = level
      else
        log("Log level not log_level_allowed", :error)
      end
    end

  end

end