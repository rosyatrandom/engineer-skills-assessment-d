require 'set'
#require 'pathname'
require_relative 'pathname_refined'

module FS
  RUBY_EXTENSION = '.rb'

  module Files
    using PathnameRefined

    def get_ruby_file_paths paths
      ruby_files, invalid = paths
        .map(&method(:to_clean_pathname))
        .reduce([Set[],[]]) do |(files, invalid), pathname|
          if pathname.ruby_file?
            files << pathname
          elsif pathname.directory?
            files.merge(ruby_files_in_dir pathname)
          else
            invalid << pathname.to_s
          end

        [files.map(&:to_s), invalid]
      end
    end

    def to_clean_pathname path
      Pathname.new(path).cleanpath
    end

    private

    def ruby_files_in_dir pathname
      Pathname.glob(pathname + "**" + "*#{RUBY_EXTENSION}")
    end
  end
end