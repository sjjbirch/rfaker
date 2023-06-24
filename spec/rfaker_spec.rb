# frozen_string_literal: true

RSpec.describe Rfaker do
  it "has a version number" do
    expect(Rfaker::VERSION).not_to be nil
  end

  describe ".rd" do

    context "given no arguments" do
      it "returns an ArgumentError" do
        expect(Rfaker.rd.to raise_error(ArgumentError))
        # TODO:
        #   This should include the correct string message as the second argument.
      end
    end

    context "given a dog name" do
      it "returns a dog name" do
        expect(Rfaker.rd([dog.name]).to_be_an_instance_of?(String))
        # TODO:
        #   This should be a more robust test.
      end
    end

  end
end
