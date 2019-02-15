require 'test\unit'
require_relative '..\..\lib\fs\matchers'

include FS::Matchers

class TestMatchers < Test::Unit::TestCase
  def test_ruby_matcher
    assert IsRubyFile === 'test/test_dir/a_ruby_file.rb'
    assert !(IsRubyFile === 'test/test_dir/a_text_file.txt')
    assert !(IsRubyFile === 'test/test_dir/no_such_file.txt')
    assert !(IsRubyFile === 'test/test_dir')
    assert !(IsRubyFile === 'test/no_such_dir')
  end

  def test_directory_matcher
    assert IsDirectory === 'test/test_dir'
    assert !(IsDirectory === 'test/no_such_dir')
    assert !(IsDirectory === 'test/test_dir/a_text_file.txt')
    assert !(IsDirectory === 'test/test_dir/no_such_file.txt')
    assert !(IsDirectory === 'test/test_dir/a_ruby_file')
  end
end