module JSONdb

  @@settings    = Settings.new
  @@constants   = Constants.new
  @@tables      = JSONdb::PaginatedHash.new
  @@fields      = JSONdb::PaginatedHash.new
  @@records     = JSONdb::PaginatedHash.new


  def self.settings
    @@settings
  end

  def self.constants
    @@constants
  end

  def self.tables
    @@tables
  end

  def self.fields
    @@fields
  end

  def self.records
    @@records
  end
end