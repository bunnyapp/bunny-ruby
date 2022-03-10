# frozen_string_literal: true

describe RecurCrm do
  it 'returns a proper version' do
    expect(RecurCrm::VERSION).to be_a(String)
  end
end