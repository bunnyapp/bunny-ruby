describe BunnyApp::Trial do
  describe 'create' do
    it 'should return a json result' do
      res = described_class.create(account_name: 'Account', first_name: 'First', last_name: 'Last', email: 'email@email.com', product_plan_code: 'Code', trial_start_date: Time.now.iso8601)
      expect(res).to eq('{}')
    end

    it 'should require all arguments excluding trial start date' do
      expect {
        described_class.create(account_name: 'Account')
      }.to raise_error(ArgumentError)
    end

    it 'should not require trial start date' do
      expect {
        described_class.create(account_name: 'Account', first_name: 'First', last_name: 'Last', email: 'email@email.com', product_plan_code: 'Code')
      }.not_to raise_error
    end
  end
end