module JSONdb

  module Logger

    # LogLevels = { 
    #   debug: 1, 
    #   info:  2, 
    #   error: 3 
    # }

    def log(msg, log_level = :debug, force_raise_error = false)
      log("Log level not allowed: '#{log_level}", :error) if !allowed_log_level?(log_level)

      if log_enabled? and log_this?(log_level)
        @log_file ||= FileOps.new(JSONdb.settings.log_folder, JSONdb.settings.log_file, 'log', false)
        @log_file.write_line("#{Time.now} #{log_level.to_s.upcase} #{self.class.to_s} #{msg}")
        puts "#{Time.now} #{log_level.to_s.upcase} #{self.class.to_s}: #{msg} " if JSONdb.settings.verbose
      end
      raise "#{log_level.to_s.upcase} #{self.class.to_s} #{msg}" if (JSONdb.settings.raise_errors == true or force_raise_error == true) and log_level == :error 
    end

    def allowed_log_level?(log_level)
      JSONdb.constants.loglevels.keys.include?(log_level)
    end

    def log_this?(log_level)
      JSONdb.constants.loglevels[log_level] >= JSONdb.constants.loglevels[JSONdb.settings.log_level]
    end

    def log_enabled?
      JSONdb.settings.log_enabled
    end
    
  end

end