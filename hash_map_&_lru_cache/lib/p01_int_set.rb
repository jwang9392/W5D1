class MaxIntSet #shortcoming: (1) potentially high space complexity depending on size of array ++ (2) out of range possibility 
attr_accessor :store

  def initialize(max)
    @store = Array.new(max,false)
    @max = max
  end

  def insert(num)
    raise "Out of bounds" if num >= @max || num < 0
    @store[num] = true
  end

  def remove(num)
    @store[num] = false
  end

  def include?(num)
    @store[num]
  end

  private

  # def is_valid?(num)

  # end

  # def validate!(num)
  # end
end


class IntSet 
  #solves the space complexity problem of MaxIntSet by buckets
  #shortcoming: lookup time likely increases based on sub-array buckets being populated with unique elements (millions or thousands of elements)
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @num_buckets = num_buckets
  end

  def insert(num)
    @store[num % @num_buckets] << num
  end

  def remove(num)
    @store[num % @num_buckets].delete(num)
  end

  def include?(num)
    @store[num % @num_buckets].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet 
  #applies concept of amortization -- 
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @num_buckets = num_buckets
    @count = 0
  end

  def insert(num)
    unless include?(num)
      @store[num % @num_buckets] << num 
      @count += 1
    end
    resize! if @count == @num_buckets
  end

  def remove(num)
    if include?(num)
      @store[num % @num_buckets].delete(num)
      @count -= 1
    end
  end

  def include?(num)
    @store[num % @num_buckets].include?(num)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    #you have O(1) look up time here until resize and the resize gets us constant time again b/c lookup in an array of 1 element is constant
  end

  def num_buckets
    @store.length
  end

  def resize!
    @num_buckets *= 2
    @count = 0
    new_arr = Array.new(@num_buckets) {Array.new}
    @store.each do |arr|
      arr.each do |ele|
        new_arr[ele % @num_buckets] << ele
        @count += 1
      end
    end
    @store = new_arr
  end
end
