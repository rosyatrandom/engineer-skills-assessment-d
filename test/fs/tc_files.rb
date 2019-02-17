require 'test\unit'
require 'set'
require 'pathname'
require_relative '..\..\lib\fs\files'

include FS::Files

class TestFiles < Test::Unit::TestCase
  def test_to_clean_pathname
    #TODO!
  end

  def test_get_ruby_file_paths
    check_results(
      %w[test_dir],
      %w[test_dir\\a_ruby_file.rb test_dir\\foo\\another_ruby_file.rb]
    )
    check_results(
      %w[no_such_dir],
      [],
      %w[no_such_dir]
    )
    check_results(
      %w[test_dir no_such_dir],
      %w[test_dir\\a_ruby_file.rb test_dir\\foo\\another_ruby_file.rb],
      %w[no_such_dir]
    )
  end

  private

  def check_results paths, expected_files, expected_invalid=[]
    files, invalid = get_ruby_file_paths paths
    assert_files_same files, expected_files
    assert_files_same invalid, expected_invalid
  end

  def assert_files_same files_1, files_2
    cleanset = ->(files) { files.map { |file| to_clean_pathname file }.to_set }

    assert_equal(cleanset[files_1], cleanset[files_2])
  end
end