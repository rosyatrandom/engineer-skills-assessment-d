require_relative 'matchers'
require 'Set'

module FS
  module Files
    include FS::Matchers

    def get_ruby_files(paths)
      ruby_files, invalid = paths
        .map { |path| clean_path path }
        .reduce([Set[],[]]) do |(files, invalid), path|
          case path
          when IsDirectory then files.merge ruby_files_in_dir(path)
          when IsRubyFile then files << path
          else invalid << path
          end

          [files, invalid]
        end
    end

    private

    def ruby_files_in_dir(path)
      glob = File.join(path, "**", "*" + RUBY_EXTENSION)
      Dir.glob glob
    end

    # Converts all backslashes to slashes
    # Converts all multiple slashes to single
    def clean_path(path)
      path
        .gsub(/\\+/, "/")
        .gsub(/\/+/, "/")
    end
  end
end