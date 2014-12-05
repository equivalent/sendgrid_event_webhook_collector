require 'pathname'
class AppPath
  def self.root
    Pathname.new(File.dirname __dir__)
  end

  def self.db_setup(engine)
    root.join('lib', "#{engine}_database_setup")
  end
end
