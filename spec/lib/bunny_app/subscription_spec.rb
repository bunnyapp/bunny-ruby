describe BunnyApp::Subscription do
  describe 'create' do
    it 'should return a json result' do
      res = described_class.create(account_name: 'Account', first_name: 'First', last_name: 'Last', email: 'email@email.com', product_plan_code: 'Code')
      expect(res).to eq('{}')
    end

    it 'should require all arguments excluding options' do
      expect {
        described_class.create(account_name: 'Account')
      }.to raise_error(ArgumentError)
    end
  end
end