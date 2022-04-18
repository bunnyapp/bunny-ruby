describe BunnyCrm::Platform do
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
  end
end