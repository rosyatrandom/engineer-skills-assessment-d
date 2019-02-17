require_relative 'options'
require_relative 'output'
require_relative 'line_predicates'
require_relative '..\lexing'
require_relative '..\predicates_checker'

module CodeLineCounter
  class CodeLineCounter
    include Options, LinePredicates, Lexing

    def count
      create_checker
      count_each_file
      get_output
    end

    private

    def create_checker
      @checker = PredicatesChecker.new
      @count_options.each { |opt| @checker[opt] = predicate_for opt }
    end

    def count_each_file
      @file_counts = @ruby_file_paths
        .to_h { |file_path| [file_path.to_s, count_file(file_path)] }
    end

    def count_file file_path
      file = File.open file_path
      get_tokens_for_each_line(file) { |file_tokens| @checker.counts_for file_tokens }
    end

    def get_output
      output = Output.new @file_counts, @invalid_paths
      output.add_summary_count if output_summary?
      output.add_each_file_count if output_each?

      output.output
    end
  end
end