require "feature"

describe Feature, :type => :model do

  let(:feature_key){ :ski_banner }
  let(:features){ { } }

  around(:each) do |example|
    original_chain = described_class.chain
    example.run
    described_class.chain = original_chain
  end

  before(:each){
    allow(described_class.configuration).to receive(:features).and_return(features)
  }

  context "when chain set" do
    before(:each) do
      described_class.chain = double("chain", :enabled? => :chain_value,
                                              :present? => true,
                                              :all      => :all_values,
                                              :all_with_enabled => :all_and_enable_state)
    end

    describe ".enabled?" do

      it "returns the chain value" do
        expect(described_class.enabled?(feature_key)).to eq :chain_value
      end
    end

    describe ".all" do

      it "requests all of the features from the chain" do
        expect(described_class.all).to eq :all_values
      end
    end

    describe ".all_with_enabled" do
      before(:each) do
        described_class.chain = double("chain", :enabled? => :enabled_state,
                                                :present? => true,
                                                :all      => [double(:feature_1, name: 'feature_1', value: 'yada'),
                                                              double(:feature_2, name: 'feature_2', value: 'yoyo') ]
                                      )
      end

      it "requests all of the features from the chain" do
        expect(described_class.all_with_enabled).to eq({'feature_1' => 'yada',
                                                        'feature_2' => 'yoyo'})
      end
    end
  end

  context "when no chain set" do
    let(:feature_key){ :ski_banner }
    let(:features){ {feature_key => true} }

    before(:each) do
      described_class.chain = double("chain", :present? => false)
    end

    describe ".enabled?" do

      it "should use the configuration" do
        expect(described_class.enabled?(feature_key)).to be(true)
      end
    end

    describe ".all" do
      it "should return an empty list" do
        expect(described_class.all).to be_empty
      end
    end
  end
end
