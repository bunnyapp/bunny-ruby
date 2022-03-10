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

    it 'is possible to set base_uri' do
      expect(fake_class).to receive(:base_uri=).with('http://example.com')
      fake_class.base_uri = 'http://example.com'
    end
  end
end