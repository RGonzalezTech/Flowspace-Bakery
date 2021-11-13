require 'rails_helper'

describe Cookie do
  subject { Cookie.new }

  describe "associations" do
    it { is_expected.to belong_to(:storage) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:storage) }
  end

  describe "#ready?" do
    context "when newly created" do
      it "should return false" do
        expect(subject.ready?).to be false
      end
    end

    context "after running set_ready" do
      it "should return true" do
        subject.set_ready(true)
        expect(subject.ready?).to be true
      end
    end
  end
end
