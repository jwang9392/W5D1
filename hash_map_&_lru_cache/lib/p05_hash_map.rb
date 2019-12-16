require_relative 'p04_linked_list'
require 'byebug'
class HashMap
  attr_accessor :count
  include Enumerable

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @num_buckets = num_buckets
    @count = 0
  end

  def include?(key)
    linked_list = @store[key.hash % num_buckets]
    linked_list.include?(key)
  end

  def set(key, val)
    linked_list = @store[key.hash % num_buckets]
    if linked_list.include?(key)
      linked_list.update(key, val)
    else  
      linked_list.append(key, val)
      @count += 1
    end
    resize! if @count >= @num_buckets
  end

  def get(key)
    @store[key.hash % num_buckets].get(key)
  end

  def delete(key)
    linked_list = @store[key.hash % num_buckets]
    linked_list.remove(key)
    @count -= 1
  end

  def each(&prc)
    i = 0
    # debugger
    while i < num_buckets
      linked_list = @store[i]
      linked_list.each do |node|
        prc.call(node.key, node.val)
      end
      i += 1
    end
  end
    

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    @num_buckets *= 2
    @count = 0
    new_store = Array.new(@num_buckets) { LinkedList.new }
    @store.each do |linked_list|
      linked_list.each do |k, v|
        linked_list.append(k, v)
        @count += 1
      end
    end
    @store = new_store
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
  end
end
