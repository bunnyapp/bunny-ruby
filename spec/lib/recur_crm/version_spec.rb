# frozen_string_literal: true

describe BunnyCrm do
  it 'returns a proper version' do
    expect(BunnyCrm::VERSION).to be_a(String)
  end
end