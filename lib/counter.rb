class Counter
  attr_reader :counts

  def initialize items
    @counts = items.to_h { |item| [item, 0] }
  end

  def increment_for items
    items.each { |item| @counts[item] += 1 }

    self
  end

  def + other
    self
      .counts
      .merge(other.counts) { |_, c1, c2| c1 + c2 }

    self
  end
end
