# frozen-string-literal: true

# For this project, we're only handling keys of type strings.

# My implemenation of a hash set
class HashSet
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

  def add(key)
    index = hash(key)

    # Check for duplicates
    return if contains(key)

    # If the bucket is nil, create a new array
    @buckets[index] ||= []
    @buckets[index].push(key)

    current_load_factor = size.to_f / @bucket_size
    resize if current_load_factor > 0.75
  end

  def resize # rubocop:disable Metrics/MethodLength
    @bucket_size *= 2
    new_buckets = Array.new(@bucket_size)

    @buckets.each do |bucket|
      next if bucket.nil?

      bucket.each do |key|
        index = hash(key)
        new_buckets[index] ||= []
        new_buckets[index].push(key)
      end
    end

    @buckets = new_buckets
  end

  # Removes a key from the hash map if it exists.
  # Returns the key removed, or nil if the key doesn't exist.
  def remove(key)
    index = hash(key)

    return nil if @buckets[index].nil?

    @buckets[index].each_with_index do |k, i|
      next unless k == key

      @buckets[index].delete_at(i)
      return key
    end
  end

  def contains(key)
    index = hash(key)

    return false if @buckets[index].nil?

    @buckets[index].each do |k|
      return true if k == key
    end

    false
  end

  def size
    count = 0

    @buckets.each do |bucket|
      next if bucket.nil?

      count += bucket.length
    end

    count
  end

  # Removes all keys from the hash set.
  def clear
    @buckets = Array.new(@bucket_size)
  end
end
