# frozen_string_literal: true

RSpec.describe Rfaker do
  it "has a version number" do
    expect(Rfaker::VERSION).not_to be nil
  end

  describe ".rd" do
    context "given no arguments" do
      it "returns strings" do
        expect(Rfaker.rd.to(be_an_instance_of(String)))
      end
    end
  end
end
