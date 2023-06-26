# frozen_string_literal: true

RSpec.describe Rfaker do
  it "has a version number" do
    expect(Rfaker::VERSION).not_to be nil
  end

  describe "FakerTree" do

    context "given no arguments" do
      it "returns an ArgumentError" do
        expect{
          Rfaker::FakerTree.new()
        }.to(raise_error(ArgumentError))
        # TODO: This should include the correct string message as the second argument.
      end
    end

    context "given a path function" do
      it "creates a new Faker_tree object which has a tree object" do
        expect(Rfaker::FakerTree.new(Rfaker::Helpers.faker_class_path(Rfaker::Helpers.faker_path)).tree).to be_an_instance_of(Hash)
        # TODO: This should be a more robust test that checks if, for eg, the tree trunk is a valid path.
      end
    end

  end
end
