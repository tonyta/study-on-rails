require "rails_helper"

RSpec.describe User, type: :model do
  describe "initialization" do
    it "autogenerates a strong password" do
      expect(subject.password).to be_present
      expect(subject.password.length).to be >= 44
    end

    it "does not overwrite an existing password" do
      described_class.create!(username: "amy", password: "password")
      subject = described_class.find_by!(username: "amy")
      expect(subject.authenticate("password")).to be subject
    end

    it "resets the username and password on dup" do
      dup_user = subject.dup
      expect(dup_user.username).to be_nil
      expect(dup_user.password).not_to eq subject.password

      expect(subject.password).to be_present
      expect(subject.password.length).to be >= 44
    end
  end

  describe "validations" do
    subject { described_class.new(username: "amy") }

    it { should be_valid }

    specify "username must be present" do
      subject.username = nil
      expect(subject).not_to be_valid

      subject.username = " "
      expect(subject).not_to be_valid
    end

    specify "username must be unique" do
      _existing_user = described_class.create!(username: "amy")
      expect(subject).not_to be_valid
    end
  end

  describe "username" do
    it "is case-insensitive" do
      subject = described_class.new(username: "DEE")
      expect(subject.username).to eq "dee"
    end
  end
end
