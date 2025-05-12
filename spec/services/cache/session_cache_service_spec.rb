require 'rails_helper'

RSpec.describe Cache::SessionCacheService do
  describe '.fetch_sessions' do
    let!(:sessions) { create_list(:session, 3) }

    it 'returns cached sessions if present' do
      Rails.cache.write(described_class::CACHE_KEY, sessions)
      expect(described_class.fetch_sessions).to eq(sessions)
    end

    it 'fetches and caches sessions if not in cache' do
      Rails.cache.delete(described_class::CACHE_KEY)
      expect(described_class.fetch_sessions.count).to eq(3)
      expect(Rails.cache.exist?(described_class::CACHE_KEY)).to be true
    end
  end

  describe '.invalidate_cache' do
    it 'removes sessions from cache' do
      Rails.cache.write(described_class::CACHE_KEY, create_list(:session, 3))
      described_class.invalidate_cache
      expect(Rails.cache.exist?(described_class::CACHE_KEY)).to be false
    end
  end
end
