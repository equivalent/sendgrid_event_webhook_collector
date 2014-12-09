class JSONFixture
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_json
    File.read(path)
  end

  def to_hash
    JSON.parse to_json
  end

  def path
    AppPath::Test
      .fixture
      .join(name)
  end
end
