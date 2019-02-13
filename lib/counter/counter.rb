require_relative '..\parsing\lexer'
require_relative '..\parsing\line_parser'
require_relative '..\options'
require_relative '..\fs\files'

module Counter
  class CodeLineCounter
    include Parsing::Lexer, Options, Paths::Files

    attr_reader :result, :options

    # Optionally include paths
  def initialize *paths
      @options = Set[]
      @result = {}
      set_paths paths if paths.any?
    end

  def set_paths paths
      @file_paths, invalid_paths = get_ruby_files paths
      @result[:invalid_paths] = invalid_paths if invalid_paths.any?
      self
    end

  def set_count options
      set_options options, COUNTS
      self
    end

    def set_output(options)
      set_options options, OUTPUTS
      self
    end

    def count
      @line_parser = Parsing::LineParser.new(@options)
      result = @file_paths.map { |file| [file, count_file(file)] }

      add_summary result if @options === OUTPUT_SUMMARY
      add_file_counts result if @options === OUTPUT_EACH

      self
    end

    private

    def count_file(file)
      get_tokens_for_each_line(file)
        .map { |types| @line_parser.parse types }
        .reduce init_counts, &method(:count_parsed)
    end

    def count_parsed(acc, parsed_line)
      parsed_line.each { |count| acc[count] += 1 }
      acc
    end

    def init_counts
      counting_options(@options).map { |opt| [opt, 0] }.to_h
    end

    def set_options(options, option_list)
      options_in_list = options & option_list
      @options.merge options_in_list
    end

    def add_summary(result)
      @result[:summary] = result
        .map { |(_, counts)| counts}
        .reduce { |acc, counts| merge_counts acc, counts }
    end

    def merge_counts(acc, counts)
      acc.merge(counts) { |type, c1, c2| c1 + c2 }
    end

    def add_file_counts(result)
      file_counts = result.to_h
      @result.merge! file_counts
    end
  end
end