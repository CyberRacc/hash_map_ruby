# frozen_string_literal: true

require_relative '../lib/hash_map'

RSpec.describe HashMap do # rubocop:disable Metrics/BlockLength
  let(:hash_map) { HashMap.new }

  describe '#set' do
    it 'sets a key-value pair in the hash map' do
      hash_map.set('name', 'John')
      expect(hash_map.get('name')).to eq('John')
    end

    it 'updates the value if the key already exists' do
      hash_map.set('name', 'John')
      hash_map.set('name', 'Jane')
      expect(hash_map.get('name')).to eq('Jane')
    end
  end

  describe '#get' do
    it 'returns the value associated with the given key' do
      hash_map.set('name', 'John')
      expect(hash_map.get('name')).to eq('John')
    end

    it 'returns nil if the key does not exist' do
      expect(hash_map.get('name')).to be_nil
    end
  end

  describe '#has' do
    it 'returns true if the key exists in the hash map' do
      hash_map.set('name', 'John')
      expect(hash_map.has('name')).to be true
    end

    it 'returns false if the key does not exist' do
      expect(hash_map.has('name')).to be false
    end
  end

  describe '#remove' do
    it 'removes a key-value pair from the hash map' do
      hash_map.set('name', 'John')
      expect(hash_map.remove('name')).to eq('John')
      expect(hash_map.get('name')).to be_nil
    end

    it 'returns nil if the key does not exist' do
      expect(hash_map.remove('name')).to be_nil
    end
  end

  describe '#length' do
    it 'returns the number of key-value pairs in the hash map' do
      hash_map.set('name', 'John')
      hash_map.set('age', 30)
      expect(hash_map.length).to eq(2)
    end

    it 'returns 0 if the hash map is empty' do
      expect(hash_map.length).to eq(0)
    end
  end

  describe '#clear' do
    it 'removes all key-value pairs from the hash map' do
      hash_map.set('name', 'John')
      hash_map.set('age', 30)
      hash_map.clear
      expect(hash_map.length).to eq(0)
    end
  end

  describe '#keys' do
    it 'returns an array of all the keys in the hash map' do
      hash_map.set('name', 'John')
      hash_map.set('age', 30)
      expect(hash_map.keys).to contain_exactly('name', 'age')
    end

    it 'returns an empty array if the hash map is empty' do
      expect(hash_map.keys).to be_empty
    end
  end

  describe '#values' do
    it 'returns an array of all the values in the hash map' do
      hash_map.set('name', 'John')
      hash_map.set('age', 30)
      expect(hash_map.values).to contain_exactly('John', 30)
    end

    it 'returns an empty array if the hash map is empty' do
      expect(hash_map.values).to be_empty
    end
  end

  describe '#entries' do
    it 'returns an array of all the key-value pairs in the hash map' do
      hash_map.set('name', 'John')
      hash_map.set('age', 30)
      expect(hash_map.entries).to contain_exactly(%w[name John], ['age', 30])
    end

    it 'returns an empty array if the hash map is empty' do
      expect(hash_map.entries).to be_empty
    end
  end
end
