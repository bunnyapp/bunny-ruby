describe BunnyApp::Client do
  let!(:client) { described_class.new }

  describe 'headers' do
    it 'should include an authorization header' do
      expect(client.headers).to include(match(/Authorization/) => 'Bearer xxx')
    end

    it 'should include a user-agent header' do
      client = described_class.new
      expect(client.headers).to include(match(/User-Agent/) => "BunnyApp Ruby v#{BunnyApp::VERSION}")
    end
  end
end