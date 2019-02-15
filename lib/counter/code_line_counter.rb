require_relative 'options'
require_relative 'item_counter'
require_relative 'output'
require_relative '..\parsing\lexer'
require_relative '..\parsing\line_parser'
require_relative '..\fs\files'

module Counter
  class CodeLineCounter
    include Parsing, Options, FS::Files

    def count
      counts = count_each_file
      get_output counts
    end

    private

    def count_each_file
      parser = LineParser.new @count_options
      @ruby_file_paths
        .to_h { |file_path| [file_path.to_s, count_file(file_path, parser)] }
    end

    def count_file file_path, parser
      counter = ItemCounter.new @count_options
      Lexer
        .get_tokens_for_each_line(File.open file_path)
        .then { |tokens_by_line| parser.parse_lines tokens_by_line }
        .each_with_object(counter) { |line_tokens, counter| counter.increment_for line_tokens }
    end

    def get_output counts
      output = Output.new counts, @invalid_paths
      output.add_summary_count if output_summary?
      output.add_each_file_count if output_each?

      output.output
    end
  end
end