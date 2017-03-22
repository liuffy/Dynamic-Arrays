require_relative "static_array"
# require 'pry'
require 'byebug'

class DynamicArray
  attr_reader :length

  def initialize
    self.store, self.capacity, self.length = StaticArray.new(8), 8, 0
  end

  # O(1)
  def [](index) # getter
    check_index(index)
    store[index]
  end

  # O(1)
  def []=(index, value)
    check_index(index)
    store[index] = value
  end

  # O(1)
  def pop
    raise "index out of bounds" unless (length > 0)

    val = self[length - 1] #val is the last el in array
    self[length - 1] = nil # set it to nil
    self.length -= 1 

    val # return the value you've removed
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if length == capacity
    self.length += 1
    self[length - 1] = val
  end

  # O(n): has to shift over all the elements.
  # shift = pop at beginning of array 
  def shift
    raise "index out of bounds" unless (length > 0)

    first_val = self[0]
    (1...length).each{|i| self[i - 1] = self[i] }
    self.length -= 1

    first_val
  end

  # O(n): has to shift over all the elements.
  #unshift = push at beginning of array
  def unshift(val)
    resize! if length == capacity

    self.length += 1
    (length - 2).downto(0).each{|i| self[i+1] = self[i]}
    self[0] = val

    nil
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    unless (index >= 0) && (index < length)
      raise "index out of bounds"
    end 
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    new_capacity = capacity * 2
    # make new StaticArray with capacity that's double the length of the original store
    new_store = StaticArray.new(new_capacity)
    # iterate and copy over all the elements to the new store 
    length.times{ |i| new_store[i] = self[i]}
    # set self.capacity to new capacity
    # set selt.store to new store 
    self.store = new_store
    self.capacity = new_capacity
  end
end
