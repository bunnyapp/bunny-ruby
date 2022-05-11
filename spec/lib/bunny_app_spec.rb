describe BunnyApp do
  it 'is possible to provide config options' do
    described_class.config do |c|
      expect(c).to eq(described_class)
    end
  end

  describe 'parameters' do
    let(:fake_class) { class_double('BunnyApp') }
    it 'is possible to set access_token' do
      expect(fake_class).to receive(:access_token=).with('xxx')
      fake_class.access_token = 'xxx'
    end
  end

  describe 'query' do
    it 'should return a json string response' do
      res = BunnyApp.query("graphql query", { variable: 1 })
      expect(res).to eq("{}")
    end

    it 'should require query and variables arguments' do
      expect { BunnyApp.query("graphql query") }.to raise_error(ArgumentError)
    end
  end
end