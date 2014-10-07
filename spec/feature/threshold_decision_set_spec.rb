require 'feature'
require 'feature/decision'
require 'feature/decision_set'
require 'feature/threshold_decision_set'
require 'json'

describe Feature::ThresholdDecisionSet, :type => :model do
  subject { described_class.build(features) }

  let(:feature_thresholds) do
    {
      some_feature: 0.3,
      some_other_feature: 0.5
    }
  end

  let(:rand_value) { 0.4 }

  before(:each) do
    allow(Feature.configuration).to receive(:feature_thresholds).and_return(feature_thresholds)
    allow(described_class).to receive(:rand).and_return(rand_value)
  end

  describe ".build" do
    let(:names) { ["some_feature", "some_other_feature"] }
    let(:values) { [false, true]}

    let(:decisions){[
        Feature::Decision.new(name: names[0], value: values[0]),
        Feature::Decision.new(name: names[1], value: values[1])
      ]
    }

    context "with a Hash of key value pairs" do
      let(:features) { {
        names[0] => values[0],
        names[1] => values[1]
      } }

      it "returns a DecisionSet with Decisions set according to random factor" do
        expect(subject.all).to match_array(decisions)
      end
    end

    context "with a JSON string" do
      let(:features){ {
        :features => {
          names[0] => values[0],
          names[1] => values[1]
        },
        :feature_thresholds => {}
      }.to_json }

      it "returns a DecisionSet with Decisions set according to random factor" do
        expect(subject.all).to match_array(decisions)
      end

      context "with existing thresholds" do
        let(:features) { {
          :features => {
            names[0] => values[0],
            names[1] => values[1]
          },
          :feature_thresholds => {
            :some_feature => 0.3,
            :some_other_feature => 0.4
          }
        }.to_json }

        it "returns a DecisionSet with Decisions set according to random factor" do
          expect(subject.all).to match_array(decisions)
        end

        context "and the configured threshold has changed" do
          let(:features) { {
            features: { some_feature: false },
            feature_thresholds: { some_feature: 0.3 }
          }.to_json}
          let(:feature_thresholds) { {some_feature: 0.6} }
          let(:rand_value) { 0.4 }
          let(:decisions) { [Feature::Decision.new(name: "some_feature", value: true)] }

          it "doesn't attempt to recalculate features where the thresholds haven't changed" do
            expect(subject.all).to match_array(decisions)
          end
        end

        context "and the configured threshold has not changed" do
          let(:features) { {
            features: { some_feature: false },
            feature_thresholds: { some_feature: 0.3 }
          }.to_json }
          let(:feature_thresholds) { {some_feature: 0.3} }
          let(:rand_value) { 0.2 }
          let(:decisions) { [Feature::Decision.new(name: "some_feature", value: false)] }

          it "doesn't attempt to recalculate features where the thresholds haven't changed" do
            expect(subject.all).to match_array(decisions)
          end
        end
      end
    end
  end
end
