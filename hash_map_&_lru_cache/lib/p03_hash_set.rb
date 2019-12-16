class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
    @num_buckets = num_buckets
  end

  def insert(key)
    @store[key.hash % num_buckets] << key
    @count += 1
    resize! if @count >= @num_buckets
  end

  def include?(key)
    @store[key.hash % num_buckets].include?(key)
  end

  def remove(key)
    if include?(key)
      @store[key.hash % num_buckets].delete(key)
      @count -= 1
    end
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
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
        new_arr[ele.hash % @num_buckets] << ele
        @count += 1
      end
    end
    @store = new_arr
  end
end
