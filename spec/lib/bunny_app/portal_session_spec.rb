describe BunnyApp::PortalSession do
  describe 'create' do
    it 'should return a hash result' do
      res = described_class.create(tenant_code: 'code')
      expect(res).to be_a(Hash)
    end

    it 'should require tenant_code argument' do
      expect {
        described_class.create()
      }.to raise_error(ArgumentError)
    end
  end
end