require 'set'
require 'pathname'

module FS
  RUBY_EXTENSION = '.rb'

  module PathnamePlus
    refine Pathname do
      def ruby_file?
        self.file? and
        (self.extname == RUBY_EXTENSION)
      end
    end
  end

  module Files
    using PathnamePlus

    def get_ruby_pathnames paths
      ruby_files, invalid = paths
        .map { |path| Pathname.new(path).cleanpath }
        .reduce([Set[],[]]) do |(files, invalid), pathname|
          if pathname.ruby_file?
            files << pathname
          elsif pathname.directory?
            files.merge(ruby_files_in_dir pathname)
          else
            invalid << pathname.to_s
          end

          [files, invalid]
        end
    end

    def clean_pathnames paths
      paths.map { |path| Pathname.new(path).cleanpath }
    end

    private

    def ruby_files_in_dir pathname
      Pathname.glob(pathname + "**" + "*#{RUBY_EXTENSION}")
    end
  end
end