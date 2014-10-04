module JSONdb

  @@settings    = Settings.new
  @@constants   = Constants.new
  @@tables      = Hash.new
  @@fields      = Hash.new
  @@records     = Hash.new


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