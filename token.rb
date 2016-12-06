class Token
  attr_accessor :type
  attr_accessor :value
  attr_accessor :position

  def initialize(type, value, position = 0)
    @type = type
    @value = value
    @position = position
  end

  def self.are_equal?(token1, token2)
    return token1.value == token2.value && token1.type == token2.type
  end
end