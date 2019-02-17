require_relative '..\fs\files'

module CodeLineCounter
  module Options
    include FS::Files

    COUNT_CODE = :code
    COUNT_BLANK = :blank
    COUNT_COMMENT = :comment

    OUTPUT_EACH = :output_each
    OUTPUT_SUMMARY = :output_summary

    # Options Groups
    COUNTS = [COUNT_CODE, COUNT_BLANK, COUNT_COMMENT]
    OUTPUTS = [OUTPUT_EACH, OUTPUT_SUMMARY]

    def set_paths paths
      @ruby_file_paths, @invalid_paths = get_ruby_file_paths paths

      self
    end

    def set_count options
      @count_options = options

      self
    end

    def set_output options
      @output_options = options
      
      self
    end

    def output_each?
      @output_options.include? OUTPUT_EACH
    end

    def output_summary?
      @output_options.include? OUTPUT_SUMMARY
    end
  end
end