require_relative 'token'

class LexicalAnalyzer
  TAGS = %w(<!ATTLIST <!ELEMENT #REQUIRED #IMPLIED #FIXED EMPTY ANY (#PCDATA) CDATA NMTOKEN IDREF SPACE)

  def self.load_input
    puts "Enter string to analyze:"
    # @input_string = gets.chomp
    # puts @input_string
    @input_string = '<!ELEMENT HEADLINE (#PCDATA) >'
    # @input_string = '<!ELEMENT ARTICLE ((HEADLINE, BYLINE, LEAD, BODY, NOTES)) >'
    # @input_string = '<!ELEMENT HEADLINE (#PCDATA) > <!ATTLIST ARTICLE SPACE AUTHOR CDATA #REQUIRED >'
    # @input_string = '<!ATTLIST PRODUCT SPACE NAME CDATA #IMPLIED CATEGORY (HandTool|Table) "HandTool SPACE super SPACE underpriced"
    #                   PARTNUM CDATA #IMPLIED PLANT (Pittsburgh|Chicago) "Chicago" INVENTORY (InStock|Backordered) "InStock" >'
    tokenize_input
  end

  def self.tokenize_input
    input_array = @input_string.split(' ')

    @tokens = []
    input_array.each do |item|
      if TAGS.include? item
        @tokens << Token.new(:tag, item)
      else
        item.split('').each { |char| @tokens << Token.new(:regular, char)}
      end
    end

  end

  def self.get_tokens
    @tokens
  end
end

# LexicalAnalyzer.load_input