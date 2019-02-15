require 'pathname'

module FS
  module PathnameRefined
    refine Pathname do
      def ruby_file?
        self.file? and
        (self.extname == RUBY_EXTENSION)
      end
    end
  end
end