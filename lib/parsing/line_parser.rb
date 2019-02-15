require_relative 'lexer'
require_relative '..\options'

module Parsing
  class LineParser
    include Options

    # options is expected to be a Set
    def initialize options
      @parse_code = options === COUNT_CODE
      @parse_comment = options === COUNT_COMMENT
      @parse_blank = options === COUNT_BLANK
    end

    def parse tokens
      output = []

      output << COUNT_CODE if @parse_code and has_code? tokens
      output << COUNT_COMMENT if @parse_comment and has_comment? tokens
      output << COUNT_BLANK if @parse_blank and is_blank? tokens

      output
    end

    private
    def is_blank? tokens
      (tokens - WHITESPACE_TOKENS).empty?
    end

    def has_comment? tokens
      (tokens & COMMENT_TOKENS).any?
    end

    def has_code?(tokens)
      (tokens - COMMENT_TOKENS - WHITESPACE_TOKENS).any?
    end
  end
end