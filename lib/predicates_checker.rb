require_relative 'counter'

class PredicatesChecker
  def initialize
    @checks = {}
  end

  def []= name, check
    @checks[name] = check
  end

  def check_item item
    @checks.transform_values { |check| check.call item }
  end

  def counts_for items
    items
      .map { |item| check_item item }
      .each_with_object(Counter.new @checks.keys) do |results, counter|
        counter.increment_for results
          .filter { |_, result| result }
          .keys
      end
  end
end