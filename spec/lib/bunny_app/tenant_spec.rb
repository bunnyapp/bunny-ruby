describe BunnyApp::Tenant do
  describe 'create' do
    it 'should return a json result' do
      res = described_class.create(name: 'Name', code: 'code')
      expect(res).to eq('{}')
    end

    it 'should require name and code arguments' do
      expect {
        described_class.create(name: 'Name')
      }.to raise_error(ArgumentError)
    end

    it 'should not require platform_code' do
      expect {
        described_class.create(name: 'Name', code: 'code')
      }.not_to raise_error
    end

    it 'should allow setting platform_code' do
      expect {
        described_class.create(name: 'Name', code: 'code', platform_code: 'platform')
      }.not_to raise_error
    end
  end
end