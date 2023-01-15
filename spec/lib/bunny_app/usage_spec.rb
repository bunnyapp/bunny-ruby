describe BunnyApp::Usage do
  describe 'track' do
    it 'should return a hash result' do
      res = described_class.track(quantity: 1, feature_code: 'code', tenant_code: 'code')
      expect(res).to eq({})
    end

    it 'should require quantity, feature_code, and tenant_code arguments' do
      expect {
        described_class.track(quantity: 1, feature_code: 'code')
      }.to raise_error(ArgumentError)
    end

    it 'should not require usage_at' do
      expect {
        described_class.track(quantity: 1, feature_code: 'code', tenant_code: 'code')
      }.not_to raise_error
    end

    it 'should allow setting usage_at' do
      expect {
        described_class.track(quantity: 1, feature_code: 'code', tenant_code: 'code', usage_at: '2022-03-11')
      }.not_to raise_error
    end
  end
end