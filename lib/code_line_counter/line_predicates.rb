require_relative '..\lexing'
require_relative 'options'

module CodeLineCounter
  module LinePredicates
    include Options, Lexing

    CODE    =  ->(tokens) { (tokens - (COMMENT_TOKENS + WHITESPACE_TOKENS)).any? }
    BLANK   = ->(tokens) { (tokens - WHITESPACE_TOKENS).empty? }
    COMENT  = ->(tokens) { (tokens & COMMENT_TOKENS).any? }

    def predicate_for option
      case option
      when COUNT_CODE     then CODE
      when COUNT_BLANK    then BLANK
      when COUNT_COMMENT  then COMENT
      end.to_proc
    end
  end
end