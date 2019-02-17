require_relative 'code_line_counter'
require_relative '..\cli'

module CodeLineCounter
  class CLICodeLineCounter < CodeLineCounter
    def run
      outputs, counts, paths, stop = CLI.new.options

      return if stop

      if paths.empty?
        p "No paths selected"
      else
        proceed outputs, counts, paths
      end
    end

    private
    def proceed outputs, counts, paths
      set_paths paths
      set_count counts
      set_output outputs
      pp count
    end

    def warn_if_empty name, coll
      if coll.empty?
        @some_empty = true
      end
    end
  end
end