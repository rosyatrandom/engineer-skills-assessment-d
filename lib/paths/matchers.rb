# classes to allow paths to be checked in case statements
module Paths
  RUBY_EXTENSION = '.rb'
  module Matchers
    class IsRubyFile
      def self.===(path)
        File.exist? path and
        File.extname path == RUBY_EXTENSION
      end
    end

    class IsDirectory
      def self.===(path)
        Dir.exist? path
      end
    end
  end
end