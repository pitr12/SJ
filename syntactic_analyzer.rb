require_relative 'lexical_analyzer'
require_relative 'token'
require_relative 'error'
require 'json'

class SyntacticAnalyzer

  NON_TERMINALS = [:dtddocument, :dtddocument2, :declaration, :elemdecl, :elemdecl2, :elemchild, :choiceseq, :choiceseq2,
    :choiceseq3, :choice, :cp, :cp2, :x, :attrdecl, :attrdecl2, :attrdecl3, :attrdecl4, :attrtype, :attrtype2, :defaultdecl,
    :defaultdecl2, :defaultdecl3, :name, :name2, :name3, :namechar, :letter, :number, :number2, :digit, :word, :word2, :char]

  RULES = {
      '1': [:dtddocument2, :declaration],
      '2': [:dtddocument],
      '3': [],
      '4': [:attrdecl],
      '5': [:elemdecl],
      '6': [Token.new(:regular, '>'), :elemdecl2, :name, Token.new(:tag, '<!ELEMENT')],
      '7': [Token.new(:tag, 'EMPTY')],
      '8': [Token.new(:tag, 'ANY')],
      '9': [Token.new(:tag, '(#PCDATA)')],
      '10': [:elemchild],
      '11': [Token.new(:regular, ')'), :x, Token.new(:regular, '(')],
      '12': [:choiceseq3, :cp, Token.new(:regular, '(')],
      '13': [:choice],
      '14': [:choiceseq2, :cp, Token.new(:regular, ',')],
      '15': [],
      '16': [Token.new(:regular, ')'), :choiceseq2],
      '17': [:cp, Token.new(:regular, '|')],
      '18': [:cp2, :name],
      '19': [:x],
      '20': [],
      '21': [Token.new(:regular, '?')],
      '22': [Token.new(:regular, '*')],
      '23': [Token.new(:regular, '+')],
      '24': [:cp2, :choiceseq],
      '25': [:attrdecl3, :name, Token.new(:tag, '<!ATTLIST')],
      '26': [:attrdecl4, :defaultdecl, :attrtype, :name],
      '27': [Token.new(:regular, '>')],
      '28': [Token.new(:regular, '>'), :attrdecl2, Token.new(:tag, 'SPACE')],
      '29': [],
      '30': [:attrdecl2],
      '31': [Token.new(:tag, 'CDATA')],
      '32': [Token.new(:tag, 'NMTOKEN')],
      '33': [Token.new(:tag, 'IDREF')],
      '34': [:attrtype2, :word, Token.new(:regular, '(')],
      '35': [Token.new(:regular, ')')],
      '36': [Token.new(:regular, ')'), :word, Token.new(:regular, '|')],
      '37': [Token.new(:tag, '#REQUIRED')],
      '38': [Token.new(:tag, '#IMPLIED')],
      '39': [Token.new(:regular, '"'), :defaultdecl2, Token.new(:regular, '"')],
      '40': [Token.new(:regular, '"'), :defaultdecl2, Token.new(:regular, '"'), Token.new(:tag, '#FIXED')],
      '41': [:defaultdecl3, :word],
      '42': [],
      '43': [:defaultdecl2, Token.new(:tag, 'SPACE')],
      '44': [:name3, :letter],
      '45': [:name3, Token.new(:regular, '_')],
      '46': [:name3, Token.new(:regular, ':')],
      '47': [:name3, :namechar],
      '48': [],
      '49': [:name2],
      '50': [:letter],
      '51': [:digit],
      '52': [Token.new(:regular, '.')],
      '53': [Token.new(:regular, '-')],
      '54': [Token.new(:regular, '_')],
      '55': [Token.new(:regular, ':')],
      '56': [Token.new(:regular, 'A')],
      '57': [Token.new(:regular, 'B')],
      '58': [Token.new(:regular, 'C')],
      '59': [Token.new(:regular, 'D')],
      '60': [Token.new(:regular, 'E')],
      '61': [Token.new(:regular, 'F')],
      '62': [Token.new(:regular, 'G')],
      '63': [Token.new(:regular, 'H')],
      '64': [Token.new(:regular, 'I')],
      '65': [Token.new(:regular, 'J')],
      '66': [Token.new(:regular, 'K')],
      '67': [Token.new(:regular, 'L')],
      '68': [Token.new(:regular, 'M')],
      '69': [Token.new(:regular, 'N')],
      '70': [Token.new(:regular, 'O')],
      '71': [Token.new(:regular, 'P')],
      '72': [Token.new(:regular, 'Q')],
      '73': [Token.new(:regular, 'R')],
      '74': [Token.new(:regular, 'S')],
      '75': [Token.new(:regular, 'T')],
      '76': [Token.new(:regular, 'U')],
      '77': [Token.new(:regular, 'V')],
      '78': [Token.new(:regular, 'W')],
      '79': [Token.new(:regular, 'X')],
      '80': [Token.new(:regular, 'Y')],
      '81': [Token.new(:regular, 'Z')],
      '82': [Token.new(:regular, 'a')],
      '83': [Token.new(:regular, 'b')],
      '84': [Token.new(:regular, 'c')],
      '85': [Token.new(:regular, 'd')],
      '86': [Token.new(:regular, 'e')],
      '87': [Token.new(:regular, 'f')],
      '88': [Token.new(:regular, 'g')],
      '89': [Token.new(:regular, 'h')],
      '90': [Token.new(:regular, 'i')],
      '91': [Token.new(:regular, 'j')],
      '92': [Token.new(:regular, 'k')],
      '93': [Token.new(:regular, 'l')],
      '94': [Token.new(:regular, 'm')],
      '95': [Token.new(:regular, 'n')],
      '96': [Token.new(:regular, 'o')],
      '97': [Token.new(:regular, 'p')],
      '98': [Token.new(:regular, 'q')],
      '99': [Token.new(:regular, 'r')],
      '100': [Token.new(:regular, 's')],
      '101': [Token.new(:regular, 't')],
      '102': [Token.new(:regular, 'u')],
      '103': [Token.new(:regular, 'v')],
      '104': [Token.new(:regular, 'w')],
      '105': [Token.new(:regular, 'x')],
      '106': [Token.new(:regular, 'y')],
      '107': [Token.new(:regular, 'z')],
      '108': [:number2, :digit],
      '109': [],
      '110': [:number],
      '111': [Token.new(:regular, '0')],
      '112': [Token.new(:regular, '1')],
      '113': [Token.new(:regular, '2')],
      '114': [Token.new(:regular, '3')],
      '115': [Token.new(:regular, '4')],
      '116': [Token.new(:regular, '5')],
      '117': [Token.new(:regular, '6')],
      '118': [Token.new(:regular, '7')],
      '119': [Token.new(:regular, '8')],
      '120': [Token.new(:regular, '9')],
      '121': [:word2, :char],
      '122': [],
      '123': [:word],
      '124': [:letter],
      '125': [:digit],
      '126': [Token.new(:regular, '!')],
      '127': [Token.new(:regular, '?')],
      '128': [Token.new(:regular, ';')],
      '129': [Token.new(:regular, '@')],
      '130': [Token.new(:regular, '&')],
      '131': [Token.new(:regular, '+')],
      '132': [Token.new(:regular, '*')],
  }

  def self.generate_char_json(rule_num, inc)
      result = {}
      rule_num -= 1 if inc
      ('A'..'Z').each { |x| result[x.to_sym] = inc ? (rule_num += 1).to_s : rule_num.to_s }
      ('a'..'z').each { |x| result[x.to_sym] = inc ? (rule_num += 1).to_s : rule_num.to_s }
      result
  end

  def self.generate_digit_json(rule_num, inc)
      result = {}
      rule_num -= 1 if inc
      ('0'..'9').each {|x| result[x.to_sym] = inc ? (rule_num += 1).to_s : rule_num.to_s }
      result
  end

  STT = {
      :dtddocument => {
          '<!ATTLIST': '1',
          '<!ELEMENT': '1'
      },
      :dtddocument2 => {
          '<!ATTLIST': '2',
          '<!ELEMENT': '2',
          '$': '3'
      },
      :declaration => {
          '<!ATTLIST': '4',
          '<!ELEMENT': '5'
      },
      :elemdecl => {
          '<!ELEMENT': '6'
      },
      :elemdecl2 => {
          'EMPTY': '7',
          'ANY': '8',
          '(#PCDATA)': '9',
          '(': '10'
      },
      :elemchild => {
          '(': '11'
      },
      :choiceseq => {
          '(': '12'
      },
      :choiceseq2 => {
          ')': '15',
          '|': '13',
          ',': '14'
      },
      :choiceseq3 => {
          ')': '16',
          '|': '16',
          ',': '16'
      },
      :choice => {
          '|': '17'
      },
      :cp => generate_char_json(18, false).merge({
          '_': '18',
          ':': '18',
          '(': '19'
      }),
      :cp2 => {
          '?': '21',
          '*': '22',
          '+': '23',
          ')': '20',
          '|': '20',
          ',': '20'
      },
      :x => {
          '(': '24'
      },
      :attrdecl => {
          '<!ATTLIST': '25'
      },
      :attrdecl2 => generate_char_json(26, false).merge({
          '_': '26',
          ':': '26'
      }),
      :attrdecl3 => {
          '>': '27',
          'SPACE': '28'
      },
      :attrdecl4 => generate_char_json(30, false).merge({
          '_': '30',
          ':': '30',
          '>': '29'
      }),
      :attrtype => {
          '(': '34',
          'CDATA': '31',
          'NMTOKEN': '32',
          'IDREF': '33'
      },
      :attrtype2 => {
          ')': '35',
          '|': '36'
      },
      :defaultdecl => {
          '#REQUIRED': '37',
          '#IMPLIED': '38',
          '"': '39',
          '#FIXED': '40'
      },
      :defaultdecl2 => generate_char_json(41, false).merge({
          '?': '41',
          '*': '41',
          '+': '41',
          '!': '41',
          ';': '41',
          '@': '41',
          '&': '41'
      }).merge(generate_digit_json(41, false)),
      :defaultdecl3 => {
          '"': '42',
          'SPACE': '43'
      },
      :name => generate_char_json(44, false).merge({
          '_': '45',
          ':': '46'
      }),
      :name2 => generate_char_json(47, false).merge({
            '_': '47',
            ':': '47',
            '.': '47',
            '-': '47'
        }).merge(generate_digit_json(47, false)),
      :name3 => generate_char_json(49, false).merge(generate_digit_json(49, false)).merge({
          '>': '48',
          '?': '48',
          '*': '48',
          '+': '48',
          ')': '48',
          '|': '48',
          ',': '48',
          'EMPTY': '48',
          'ANY': '48',
          '(#PCDATA)': '48',
          '(': '48',
          'CDATA': '48',
          'NMTOKEN': '48',
          'IDREF': '48',
          'SPACE': '48',
          '_': '49',
          ':': '49',
          '-': '49',
          '.': '49'
      }),
      :namechar => generate_char_json(50, false).merge(generate_digit_json(51, false)).merge({
             '_': '54',
             ':': '55',
             '.': '52',
             '-': '53',
         }),
      :letter => generate_char_json(56, true),
      :number => generate_digit_json(108, false),
      :number2 => generate_digit_json(110, false),
      :digit => generate_digit_json(111, true),
      :word => generate_char_json(121, false).merge(generate_digit_json(121, false)).merge({
           '?': '121',
           '*': '121',
           '+': '121',
           '!': '121',
           ';': '121',
           '@': '121',
           '&': '121'
       }),
      :word2 => generate_char_json(123, false).merge(generate_digit_json(123, false)).merge({
            '?': '123',
            '*': '123',
            '+': '123',
            '!': '123',
            ';': '123',
            '@': '123',
            '&': '123',
            ')': '122',
            '|': '122',
            '"': '122',
            'SPACE': '122'
        }),
      :char => generate_char_json(124, false).merge(generate_digit_json(125, false)).merge({
            '?': '127',
            '*': '132',
            '+': '131',
            '!': '126',
            ';': '128',
            '@': '129',
            '&': '130'
        })
  }

  def self.analyze
    input = LexicalAnalyzer.get_tokens
    original_input = LexicalAnalyzer.get_input_string

    puts input.inspect

    stack = []
    stack << :dtddocument

    pop_input = true
    pop_stack = true
    accepted = true

    errors = []

    while stack.size > 0
      actual_stack_item = stack.pop if pop_stack
      actual_input_token = input.shift if pop_input

      puts "Stack: #{stack.inspect} \n\n"
      puts "Remaining tokens: #{input.inspect}\n\n"

      puts "Actual stack item: #{actual_stack_item.inspect}\n\n"
      puts "Actual token: #{actual_input_token.inspect}\n\n"

      if NON_TERMINALS.include? actual_stack_item
        rule = STT[actual_stack_item][actual_input_token.value.to_sym]
        puts "Applied rule: #{rule}"
        if rule
          stack += RULES[rule.to_sym]
          pop_input = false
          pop_stack = true
        else
          puts "Unaccepted token!"
          errors << Error.new(actual_input_token.position, STT[actual_stack_item].keys.map{|k| k.to_s }, actual_input_token.value)
          pop_input = true
          accepted = false
          pop_stack = false
        end
      else
        if Token.are_equal?(actual_stack_item, actual_input_token)
          pop_input = true
          pop_stack = true
          puts "Accepted token"
        else
          puts "Unaccepted token!"
          errors << Error.new(actual_input_token.position, actual_stack_item.value, actual_input_token.value)
          pop_input = true
          accepted = false
          pop_stack = false
        end
      end

      puts "-------------------------------"
    end

    puts "\n\n"

    if input.size == 0 && accepted
      puts " -------------- INPUT ACCEPTED! ----------------"
      puts original_input
    else
      puts "--------------- INPUT REJECTED! --- #{errors.size} errors found!!! ---------------"
      puts original_input
      errors.each do |error|
        Error.print_error error
      end
    end

  end
end

LexicalAnalyzer.load_input
SyntacticAnalyzer.analyze
