module JSONdb

  class Constants

    attr_reader :default_file_content, :loglevels

    def initialize
      @default_file_content = {
          'db'      => "{ \"tables\": {}, \"db\": { \"created_at\": #{Time.now.to_i}, \"updated_at\": #{Time.now.to_i} } }",
          'table'   => '{ }',
          'log'     => '',
          'raw'     => ''
        }
      @loglevels = {
        debug: 1, 
        info:  2, 
        error: 3 
      }
    end

  end

end