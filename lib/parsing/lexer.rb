require 'ripper'

module Parsing
  COMMENT_TOKENS = %i(comment embdoc_beg embdoc embdoc_end)
  WHITESPACE_TOKENS = %i(nl ignored_nl sp)
  CUSTOM_ML_STRING_TOKEN = :within_multi_line_string

  module Lexer
    # Tokenizes file and returns hash with
    # - keys: line numbers
    # - values: array of tokens for that line
    def self.get_tokens_for_each_line src
      Ripper
        .lex(src)
        .then(&method(:group_tokens_by_line_num))
        .then(&method(:add_missing_lines))
        .values
    end

    private_class_method

    def self.group_tokens_by_line_num token_data
      array_hash = Hash.new { |h,k| h[k] = [] }
      token_data
        .map { |((line, _), event)| { line => [to_token(event)] } }
        .reduce(array_hash) do |acc, data|
          acc.merge(data) { |_, arr, token| arr + token }
        end
    end

    def self.to_token event
      event
        .to_s
        .delete_prefix('on_')
        .to_sym
    end

    # For some multi-line string-type expressions, Ripper#lex will not return
    # any information for lines within it, as it's considered part of the
    # string. This does not occur for multi-line comments, so we can assume
    # that any missing lines are inside some multi-line string
    def self.add_missing_lines tokens_by_line_num
      keys = tokens_by_line_num.keys
      
      (2...keys.max)
        .reject { |i| keys.include? i }
        .each { |l| tokens_by_line_num[l] << CUSTOM_ML_STRING_TOKEN }

      tokens_by_line_num
    end
  end
end