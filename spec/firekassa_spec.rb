# frozen_string_literal: true

RSpec.describe Firekassa do
  it "has a version number" do
    expect(Firekassa::VERSION).not_to be nil
  end

  it "just should be green" do
    expect(true).to eq(true)
  end
end
