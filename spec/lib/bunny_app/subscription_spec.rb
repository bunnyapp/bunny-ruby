describe BunnyApp::Subscription do
  describe 'create' do

    before(:each) do
      response_body = {
        "data" => {
          "subscriptionCreate" => {
            "subscription" => {}
          }
        }
      }
      allow_any_instance_of(BunnyApp::Client).to receive(:query).and_return(response_body)
    end

    it 'should return a hash result' do
      res = described_class.create(price_list_code: 'Code', options: {
        account_name: 'Account',
        first_name: 'First',
        last_name: 'Last',
        email: 'email@email.com'
      })
      expect(res).to be_a(Hash)
    end

    it 'should require all arguments excluding options' do
      expect {
        described_class.create(account_name: 'Account')
      }.to raise_error(ArgumentError)
    end
  end
end