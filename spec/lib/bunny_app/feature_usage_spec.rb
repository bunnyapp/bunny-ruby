describe BunnyApp::FeatureUsage do
  describe 'create' do

    before(:each) do
      response_body = {
        "data" => {
          "featureUsageCreate" => {
            "featureUsage" => {}
          }
        }
      }
      allow_any_instance_of(BunnyApp::Client).to receive(:query).and_return(response_body)
    end

    it 'should return a hash result' do
      res = described_class.create(quantity: 1, feature_code: 'code', subscription_id: 123)
      expect(res).to be_a(Hash)
    end

    it 'should require quantity, feature_code, and subscription_id arguments' do
      expect {
        described_class.create(quantity: 1, feature_code: 'code')
      }.to raise_error(ArgumentError)
    end

    it 'should not require usage_at' do
      expect {
        described_class.create(quantity: 1, feature_code: 'code', subscription_id: 123)
      }.not_to raise_error
    end

    it 'should allow setting usage_at' do
      expect {
        described_class.create(quantity: 1, feature_code: 'code', subscription_id: 123, usage_at: '2022-03-11')
      }.not_to raise_error
    end
  end
end