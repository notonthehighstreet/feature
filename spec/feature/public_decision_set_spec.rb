require "feature/public_decision_set"

describe Feature::PublicDecisionSet do
  let(:features) do
    {
      "turn_off_ssl" => "1",
      "af"           => "true",
      "feature2"     => "no",
      "feature3"     => true
    }
  end

  let(:abbreviations) do
    { af: "abbreviated_feature" }
  end

  let(:whitelist) { %w(abbreviated_feature feature2 feature3) }

  subject { described_class.new(features) }

  describe "#all" do
    before(:each) do
      allow(Feature.configuration).to receive(:whitelist).and_return(whitelist)
      allow(Feature.configuration).to receive(:abbreviations).and_return(abbreviations)
    end

    it "rejects everything but the whitelisted features" do
      expect(subject.all.map{|dec| dec.name}).to eq(whitelist)
    end

    it "converts all values to Booleans" do
      expect(subject.all.map{|dec| dec.value}).to eq([true, false, true])
    end

    it "expands abbreviations to the full feature name" do
      expect(subject.all.map{|dec| dec.name}).to include("abbreviated_feature")
    end
  end
end

