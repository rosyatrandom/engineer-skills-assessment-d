require 'ripper'

module Parsing
  COMMENT_TOKENS = %i(comment embdoc_beg embdoc embdoc_end)
  WHITESPACE_TOKENS = %i(nl ignored_nl sp)
  CUSTOM_ML_STRING_TOKEN = :within_multi_line_string

  module Lexer
    def get_tokens_for_each_line(path)
      file = File.open path
      lex_file file
    end

    private

    # Tokenizes file and returns hash with
    # - keys: line numbers
    # - values: array of tokens for that line
    def lex_file(file)
      Ripper
        .lex(file)
        .then { |lexed| group_tokens_by_line_num lexed }
        .then { |grouped| add_missing_lines grouped }
        .values
    end

    private

    def group_tokens_by_line_num token_data
      token_data.reduce({}) do |acc, item|
        (line_num,), event = item
        token = event_to_token event
        (acc[line_num] ||= []) << token

        acc
      end
    end

    def event_to_token(event)
      event
        .to_s
        .delete_prefix('on_')
        .to_sym
    end

    # For some multi-line string-type expressions, Ripper#lex will not return
    # any information for lines within it, as it's considered part of the
    # string. This does not occur for multi-line comments, so we can assume
    # that any missing lines are inside some multi-line string
    def add_missing_lines tokens_by_line_num
      keys = tokens_by_line_num.keys
      max_line = keys.max
      missing_lines = (2...max_line).reject { |i| keys.include? i }
      tokens_by_missing_lines = missing_lines
        .map { |l| [l, [CUSTOM_ML_STRING_TOKEN]] }
        .to_h

      tokens_by_line_num.merge tokens_by_missing_lines
    end
  end
end