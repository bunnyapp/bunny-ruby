describe BunnyApp::Client do
  let!(:client) { described_class.new }

  describe 'headers' do
    it 'should include an authorization header' do
      expect(client.headers).to include(match(/Authorization/) => 'Bearer xxx')
    end

    it 'should include a user-agent header' do
      expect(client.headers).to include(match(/User-Agent/) => "BunnyApp Ruby v#{BunnyApp::VERSION}")
    end
  end

  describe 'query' do
    describe 'when ok response payload contains errors' do
      let(:response) { instance_double(HTTParty::Response, code: 200, body: '{"data":{"subscriptionCreate":null},"errors":[{"message":"Price list not found and Trial is not allowed on this price list","locations":[{"line":2,"column":5}],"path":["subscriptionCreate"]}]}') }

      before do
        allow(described_class).to receive(:post).and_return(response)
      end

      it 'should raise an exception' do
        expect{
          client.query('query', {})
        }.to raise_error(BunnyApp::ResponseError)
      end
    end
  end
end