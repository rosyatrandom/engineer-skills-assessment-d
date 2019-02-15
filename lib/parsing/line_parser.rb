require_relative 'lexer'
require_relative '..\counter\options'

module Parsing
  class LineParser
    include Counter::Options

    def initialize options
      @parse_code = options.include? COUNT_CODE
      @parse_comment = options.include? COUNT_COMMENT
      @parse_blank = options.include? COUNT_BLANK
    end

    def parse_lines lines_tokens
      lines_tokens.map { |line_tokens| parse line_tokens }
    end

    private

    def parse tokens
      counts = []

      counts << COUNT_CODE if @parse_code and has_code? tokens
      counts << COUNT_COMMENT if @parse_comment and has_comment? tokens
      counts << COUNT_BLANK if @parse_blank and is_blank? tokens

      counts
    end

    def is_blank? tokens
      (tokens - WHITESPACE_TOKENS).empty?
    end

    def has_comment? tokens
      (tokens & COMMENT_TOKENS).any?
    end

    def has_code? tokens
      (tokens - COMMENT_TOKENS - WHITESPACE_TOKENS).any?
    end
  end
end