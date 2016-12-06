class Error
  attr_accessor :position
  attr_accessor :expected
  attr_accessor :found

  def initialize (position, expected, found)
    @position = position
    @expected = expected
    @found = found
  end

  def self.print_error(error)
    puts "--- Syntax error on position #{error.position} ---"
    puts "\tExpected: \"#{error.expected}\""
    puts "\tFound: \"#{error.found}\""
  end
end