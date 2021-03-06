require 'test\unit'
require 'set'
require_relative '..\..\lib\code_line_counter\options'

include CodeLineCounter::Options

class TestOptions < Test::Unit::TestCase
  def check_counting_options
    assert_equal counting_options([COUNT_CODE]), [COUNT_CODE]
    assert_equal counting_options([OUTPUT_EACH]), []
    assert_equal(
      counting_options([:other_option, COUNT_CODE, COUNT_BLANK ]),
      [COUNT_CODE, COUNT_BLANK]
    )
  end

  def check_output_options
    assert_equal summary_options([COUNT_CODE]), []
    assert_equal summary_options([OUTPUT_EACH]), [OUTPUT_EACH]
    assert_equal(
      summary_options([:other_option, OUTPUT_EACH, OUTPUT_SUMMARY ]),
      [OUTPUT_EACH, OUTPUT_SUMMARY]
    )
  end
end