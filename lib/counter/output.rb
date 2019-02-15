module Counter
  class Output
    attr_reader :output

    def initialize counts, invalid_paths
      @counts = counts
      @output = {}
      @output[:invalid_paths] = invalid_paths if invalid_paths.any?
    end

    def add_summary_count
      @output[:summary] = @counts
        .values
        .reduce(&:+)
        .counts
    end

    def add_each_file_count
      @output.merge! @counts.transform_values(&:counts)
    end
  end
end