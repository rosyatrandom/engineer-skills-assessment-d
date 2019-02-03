require 'test\unit'
require 'Set'
require_relative '..\..\lib\paths\files'

include Paths::Files

class TestFiles < Test::Unit::TestCase
  def check_results(paths, expected_files, expected_invalid=[])
    files, invalid = get_ruby_files(paths)
    assert_equal files.to_set, expected_files.to_set
    assert_equal invalid.to_set, expected_invalid.to_set
  end
  
  def test_get_ruby_files
    check_results(
      ['test/test_dir'],
      ['test/test_dir/a_ruby_file.rb', 'test/test_dir/foo/another_ruby_file.rb']
    )
    check_results(['test/no_such_dir'], [], ['test/no_such_dir'])
    check_results(
      ['test/test_dir', 'test/no_such_dir'],
      ['test/test_dir/a_ruby_file.rb', 'test/test_dir/foo/another_ruby_file.rb'],
      ['test/no_such_dir']
    )
  end
end