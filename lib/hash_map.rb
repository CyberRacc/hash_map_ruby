# frozen-string-literal: true

# For this project, we're only handling keys of type strings.

# My implemenation of a hash map
class HashMap
  def initialize
    @bucket_size = 16
    @buckets = Array.new(@bucket_size)
  end

  # Takes a key and produces a hash code with it.
  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    # Returns the hash code modulo the bucket size to ensure it fits within the bucket size.
    hash_code % @bucket_size
  end

  # Calculates the index for the key using the hash method
  # Checks if the key already exists in the bucket
  # If it does, updates the value
  # If it doesn't, creates a new key-value pair
  # Handles collisions, possibly by using a linked list at each index
  # Checks the load factor and resizes the bucket if necessary
  # The load order is a ratio of the number of key-value pairs to the bucket size (number of buckets)
  def set(key, value)
    index = hash(key)

    # `||=` is shorthand for "if the left side is nil, then assign the right side to it"
    # This means if the current bucket is nil, it will be assigned an empty array
    @buckets[index] ||= []

    found = false
    # Check if the key already exists in the bucket
    @buckets[index].each do |pair|
      next unless pair[0] == key

      # if the key exists, update the value
      pair[1] = value
      found = true
      break
    end

    # If the key doesn't exist, create a new key-value pair
    @buckets[index].push([key, value]) unless found

    # Calculate the current load factor and resize the bucket if necessary
    current_load_factor = length.to_f / @bucket_size
    resize if current_load_factor > 0.75
  end

  # Resizes the bucket by doubling the bucket size
  # Rehashes all the key-value pairs and puts them into the new bucket
  # This is done to reduce the load factor and improve performance
  # The load factor is a ratio of the number of key-value pairs to the bucket size (number of buckets)
  # The load factor is calculated by dividing the number of key-value pairs by the bucket size
  def resize # rubocop:disable Metrics/MethodLength
    @bucket_size *= 2
    new_buckets = Array.new(@bucket_size)

    @buckets.each do |bucket|
      next if bucket.nil?

      bucket.each do |pair|
        index = hash(pair[0])
        new_buckets[index] ||= []
        new_buckets[index].push(pair)
      end
    end

    @buckets = new_buckets
  end

  # Returns the value associated with the given key if it exists.
  # Returns nil if the key doesn't exist.
  def get(key)
    index = hash(key)

    return nil if @buckets[index].nil?

    @buckets[index].each do |pair|
      return pair[1] if pair[0] == key
    end

    nil
  end

  # Returns true if the key exists in the hash map, false otherwise.
  def has(key)
    # Explicit return is needed here to stop execution if the key is found
    return true unless get(key).nil?

    false
  end

  # Removes a key-value pair from the hash map if it exists.
  # Returns the value removed, or nil if the key doesn't exist.
  def remove(key)
    index = hash(key)

    return nil if @buckets[index].nil?

    @buckets[index].each_with_index do |pair, pair_index|
      next unless pair[0] == key

      # Remove the key-value pair from the bucket
      @buckets[index].delete_at(pair_index)
      return pair[1]
    end
  end

  # Returns the number of key-value pairs in the hash map.
  def length
    count = 0

    @buckets.each do |bucket|
      count += bucket.length unless bucket.nil?
    end

    count
  end

  # Removes all key-value pairs from the hash map.
  def clear
    @buckets = Array.new(@bucket_size)
  end

  # Returns an array that contains all the keys in the hash map.
  def keys
    bucket_keys = []

    @buckets.each do |bucket|
      next if bucket.nil?

      bucket.each do |pair|
        bucket_keys.push(pair[0])
      end
    end

    bucket_keys
  end

  # Returns an array that contains all the values in the hash map.
  def values
    bucket_values = []

    @buckets.each do |bucket|
      next if bucket.nil?

      bucket.each do |pair|
        bucket_values.push(pair[1])
      end
    end

    bucket_values
  end

  # Returns an array that contains each key-value pair.
  # In the format: [[first_key, first_value], [second_key, second_value]]
  def entries
    bucket_entries = []

    @buckets.each do |bucket|
      next if bucket.nil?

      bucket.each do |pair|
        bucket_entries.push(pair)
      end
    end

    bucket_entries
  end
end
