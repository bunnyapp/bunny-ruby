describe BunnyApp::Platform do
  describe 'create' do
    it 'should return a hash result' do
      res = described_class.create(name: 'Name', code: 'code')
      expect(res).to be_a(Hash)
    end

    it 'should require name and code arguments' do
      expect {
        described_class.create(name: 'Name')
      }.to raise_error(ArgumentError)
    end
  end
end