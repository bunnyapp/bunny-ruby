describe BunnyApp::Tenant do
  describe 'create' do

    before(:each) do
      response_body = {
        "data" => {
          "tenantCreate" => {
            "tenant" => {}
          }
        }
      }
      allow_any_instance_of(BunnyApp::Client).to receive(:query).and_return(response_body)
    end

    it 'should return a hash result' do
      res = described_class.create(name: 'Name', code: 'code', account_id: 1)
      expect(res).to be_a(Hash)
    end

    it 'should require name and code arguments' do
      expect {
        described_class.create(name: 'Name')
      }.to raise_error(ArgumentError)
    end

    it 'should not require platform_code' do
      expect {
        described_class.create(name: 'Name', code: 'code', account_id: 1)
      }.not_to raise_error
    end

    it 'should allow setting platform_code' do
      expect {
        described_class.create(name: 'Name', code: 'code', platform_code: 'platform', account_id: 1)
      }.not_to raise_error
    end
  end
end