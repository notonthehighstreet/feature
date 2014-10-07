require 'feature/decision'
require 'feature/decision_set'
require 'feature/always_false'
require 'json'

describe Feature::DecisionSet, :type => :model do
  subject { described_class.build(*features) }

  describe ".build" do
    let(:names) { ["some_feature", "some_other_feature"] }
    let(:values) { ["some_value", true]}

    let(:decisions){[
        Feature::Decision.new(name: names[0], value: values[0]),
        Feature::Decision.new(name: names[1], value: values[1])
      ]
    }

    context "with a Hash of key value pairs" do
      let(:features) {[
        {names[0] => values[0]},
        {names[1] => values[1]}
      ]}

      it "returns a DecisionSet with valid Decision" do
        expect(subject.all).to match_array(decisions)
      end
    end

    context "with a JSON string" do
      let(:features){ {
        names[0] => values[0],
        names[1] => values[1]
      }.to_json }

      it "returns a DecisionSet with valid Decision" do
        expect(subject.all).to match_array(decisions)
      end
    end

    context "with a mixture of JSON and Hashes" do
      let(:features) {[
        {names[0] => values[0]},
        {names[1] => values[1]}.to_json
      ]}

      it "returns a DecisionSet with valid Decision" do
        expect(subject.all).to match_array(decisions)
      end
    end
  end

  describe "chaining" do
    let(:features) { [{variant_key: true}] }

    it "returns a value if this decision applies" do
      expect( subject.enabled?(:variant_key) ).to be_truthy
    end

    it "asks the successor if it considers an unknown decision to be enabled." do
      instance = described_class.build( {} ).chain(subject)
      expect( instance.enabled?(:variant_key) ).to be_truthy
    end

    it "returns false if there is no successor" do
      expect( subject.enabled?(:an_unknown_key) ).to be false
    end

    it "returns self when chained for additional chaining" do
      chained_decision_set = double.as_null_object
      expect( subject.chain(chained_decision_set) ).to eq(subject)
    end
  end

  describe "#enabled?" do
    let(:features) { [{christmas_banner: true}] }

    it "returns the value from the hash" do
      expect(subject.enabled?(:christmas_banner)).to be_truthy
      expect(subject.enabled?(:easter_banner)).to be_falsey
    end

    it "returns indifferent results" do
      expect(subject.enabled?('christmas_banner')).to be_truthy
      expect(subject.enabled?(:christmas_banner)).to be_truthy
    end
  end

  describe "#all" do
    let(:successor) { double 'successor', :all => [
      Feature::Decision.new(name: "in_both", value: false),
      Feature::Decision.new(name: "only_in_successor", value: true)
    ] }

    let(:features) { [
      {in_both: :new_value},
      {irrelevant: :true }
    ] }

    before(:each) do
      subject.chain(successor)
    end

    it "updates the all hash with its values" do
      expect(subject.all.select { |d| d.name == "in_both" }.first.value).to eq(:new_value)
    end

    it "passes through succesor key-values that aren't in its hash" do
      expect(subject.all.map(&:name)).to_not include("irrelevant")
    end

    it "does not add new keys and passes through all keys from the successor" do
      expect(subject.all.map(&:name)).to match_array(["in_both", "only_in_successor"])
    end
  end
end
