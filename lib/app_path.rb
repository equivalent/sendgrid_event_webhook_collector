require 'pathname'
class AppPath
  def self.root
    Pathname.new(File.dirname __dir__)
  end
end
