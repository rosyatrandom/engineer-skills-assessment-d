require_relative '..\lexing'
require_relative 'options'

module CodeLineCounter
  module LinePredicates
    include Options, Lexing

    def predicate_for option
      case option
      when COUNT_CODE
        ->(tokens) { (tokens - (COMMENT_TOKENS + WHITESPACE_TOKENS)).any? }
      when COUNT_BLANK
        ->(tokens) { (tokens - WHITESPACE_TOKENS).empty? }
      when COUNT_COMMENT
        ->(tokens) { (tokens & COMMENT_TOKENS).any? }
      else
        raise "invalid option: #{option}"
      end
    end
  end
end