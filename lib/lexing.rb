require 'ripper'

module Lexing
  COMMENT_TOKENS = %i(comment embdoc_beg embdoc embdoc_end)
  WHITESPACE_TOKENS = %i(nl ignored_nl sp)
  CUSTOM_ML_STRING_TOKEN = :within_multi_line_string

  # Tokenizes file and returns hash with
  # - keys: line numbers
  # - values: array of tokens for that line
  def get_tokens_for_each_line src
    tokens = Ripper
      .lex(src)
      .then { |lexed| group_tokens_by_line_num lexed }
      .then { |grouped| add_missing_lines grouped }
      .values

    if block_given? then yield tokens else tokens end
  end

  private_class_method

  def group_tokens_by_line_num token_data
    token_data
      .map { |((line, _), event)| { line => [to_token(event)] } }
      .reduce({}) do |acc, data|
        acc.merge(data) { |_, arr, token| arr + token }
      end
  end

  def to_token event
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

    (1..keys.max)
      .to_h do |line_num|
        tokens = tokens_by_line_num[line_num] || [CUSTOM_ML_STRING_TOKEN]
        [line_num, tokens]
      end
  end
end