describe BunnyApp::PortalSession do
  describe 'create' do
    before(:each) do
      response_body = {
        "data" => {
          "portalSessionCreate" => {
            "token" => ""
          }
        }
      }
      allow_any_instance_of(BunnyApp::Client).to receive(:query).and_return(response_body)
    end

    it 'should return a string result' do
      res = described_class.create(tenant_code: 'code')
      expect(res).to be_a(String)
    end

    it 'should require tenant_code argument' do
      expect {
        described_class.create()
      }.to raise_error(ArgumentError)
    end
  end
end