module Options
  COUNT_CODE = :code
  COUNT_BLANK = :blank
  COUNT_COMMENT = :comment

  OUTPUT_EACH = :output_each
  OUTPUT_SUMMARY = :output_summary

  # Options Groups
  COUNTS = [COUNT_CODE, COUNT_BLANK, COUNT_COMMENT]
  OUTPUTS = [OUTPUT_EACH, OUTPUT_SUMMARY]

  def counting_options options
    options & COUNTS
  end

  def output_options options
    options & OUTPUTS
  end
end