require 'optparse'
require_relative 'counter\options'

class CLI
  include Counter::Options

  attr_reader :options

  def self.running_from_cli? file_name
    file_name == $0
  end

  def initialize options=ARGV
    # parser strips all but paths from options
    paths = get_options_from_cli options
    set_default_counts if @count_options.empty?
    set_default_outputs if @output_options.empty?

    @options = [@output_options, @count_options, paths, @stop]
  end

  private

  def get_options_from_cli options
    set_default_opts options
    initialize_options

    OptionParser.new do |opts|
      set_banner opts
      define_options opts
    end.parse! options

    options
  end

  def initialize_options
    @count_options = []
    @output_options = []
  end

  def set_banner opts
    opts.banner = <<~BANNER
      code_line_counter.rb [options] path1 path2 ..."
      paths can be:
      - .rb files
      - directories (which will be recursively scanned for .rb files)
      if no counting/output options are specified, all will be set

      output format is a hash:
      {
        'file_path_1' => { count_type_1: count, ... },
        ...
        total: { count_type_1: count, ... }
      }
    BANNER
  end

  def set_default_opts options
    options << "-h" if  options.empty?
  end

  def define_options opts
    opts.on("-s", "--output-summary", "outputs total counts of all files") do
      @output_options << OUTPUT_SUMMARY
    end
    opts.on("-e", "--output-each-file", "outputs counts for each file") do
      @output_options << OUTPUT_EACH
    end
    opts.on("-b", "--count-blank-lines", "count number of blank lines") do
      @count_options << COUNT_BLANK
    end
    opts.on("-c", "--count-comments", "count number of comment lines") do
      @count_options << COUNT_COMMENT
    end
    opts.on("-r", "--count-ruby-code", "count number of ruby code lines") do
      @count_options << COUNT_CODE
    end
    opts.on("-h", "--help", "prints this help") do
      puts opts
      @stop = true
    end
  end

  # Set all counting options are true
  def set_default_counts
    @count_options = COUNTS
  end

  # Set all output options to true
  def set_default_outputs
    @output_options = OUTPUTS
  end
end