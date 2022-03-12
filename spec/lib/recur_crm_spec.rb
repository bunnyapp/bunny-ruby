describe RecurCrm do
  it 'is possible to provide config options' do
    described_class.config do |c|
      expect(c).to eq(described_class)
    end
  end

  describe 'parameters' do
    let(:fake_class) { class_double('RecurCrm') }
    it 'is possible to set api_key' do
      expect(fake_class).to receive(:api_key=).with('xxx')
      fake_class.api_key = 'xxx'
    end
  end

  describe 'query' do
    it 'should return a json string response' do
      res = RecurCrm.query("graphql query", { variable: 1 })
      expect(res).to eq("{}")
    end

    it 'should require query and variables arguments' do
      expect { RecurCrm.query("graphql query") }.to raise_error(ArgumentError)
    end
  end
end