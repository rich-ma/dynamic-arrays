require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @capacity = 8
    @store = StaticArray.new(8)
    @length = 0
    @start_idx = 0
  end

  # O(1)
  def [](index)
    check_index(index)
    idx = (@start_idx + index) % @capacity
    @store[idx]
  end

  # O(1)
  def []=(index, val)
    check_index(index)
    idx = (@start_idx + index) % @capacity
    @store[idx] = val
  end

  # O(1)
  def pop
    raise "index out of bounds" if length < 1
    @length -= 1
    idx = (@start_idx + @length) % @capacity
    @store[idx]
  end

  # O(1) ammortized
  def push(val)
    resize! if @length == @capacity
    idx = (@start_idx + @length) % @capacity
    @store[idx] = val
    @length += 1
  end

  # O(1)
  def shift
    raise "index out of bounds" if length < 1
    @start_idx += 1
    @length -= 1
    @store[@start_idx - 1]
  end

  # O(1) ammortized
  def unshift(val)
    resize! if @length == @capacity
    @start_idx -= 1
    idx = @start_idx % @capacity
    @store[idx] = val
    @length += 1
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" if index >= @length
    raise "index out of bounds" if length < 1
  end

  def resize!
    arr = StaticArray.new(@capacity * 2)
    @capacity.times do |i|
      arr[i] = @store[@start_idx + i]
    end
    @start_idx = 0
    @store = arr
    @capacity *= 2
  end
end
