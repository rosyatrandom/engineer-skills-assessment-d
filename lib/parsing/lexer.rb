require 'ripper'

module Parsing
  COMMENT_TOKENS = %i(comment embdoc_beg embdoc embdoc_end)
  WHITESPACE_TOKENS = %i(nl ignored_nl sp)

  module Lexer
    def get_tokens_for_each_line(path)
      file = File.open path
      lex_file file
    end

    private

    # Tokenizes file and returns array of tokens for each line
    def lex_file(file)
      Ripper
        .lex(file)
        .reduce({}) do |acc, item|
          (line_num,), event = item
          token = event_to_token event
          (acc[line_num] ||= []) << token

          acc
        end.map { |_, types| types }
    end

    def event_to_token(event)
      event
        .to_s
        .delete_prefix('on_')
        .to_sym
    end
  end
end