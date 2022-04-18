# frozen_string_literal: true

describe BunnyApp do
  it 'returns a proper version' do
    expect(BunnyApp::VERSION).to be_a(String)
  end
end