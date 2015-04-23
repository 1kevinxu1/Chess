class Array

  def my_each(&prc)
    i = 0
    until self.length == i do
      value = prc.call(self[i])
      i += 1
      value
    end
  end

  def my_map(&prc)
    mapped = []
    self.my_each do |value|
      mapped << prc.call(value)
    end
    mapped
  end

  def my_select(&prc)
    selected = []
    self.my_each do |value|
      selected << value if prc.call(value)
    end
    selected
  end

  def my_inject(&prc)
    return self if self.length < 1
    total = self[0]
    self.my_each do |value|
      next if value == self[0]
      total = prc.call(total, value)
    end
    total
  end

end
