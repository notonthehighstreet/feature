require_relative '../feature'
require_relative 'decision_set'

module Feature
  class PublicDecisionSet < DecisionSet
    TRUTHY_VALUES = ["true", "1", true]

    def initialize(features = {})
      super(
        whitelist(booleanize(features))
      )
    end

    private

    def booleanize(features)
      features.inject({}) do |memo, (feature_name, feature_value)|
        memo.tap do
          memo[abbreviations[feature_name.to_sym] || feature_name] = TRUTHY_VALUES.include?(feature_value)
        end
      end
    end

    def whitelist(features)
      whitelist = Feature.configuration.whitelist
      features.keep_if {|key, value| whitelist.include?(key)}
    end

    def abbreviations
      Feature.configuration.abbreviations
    end
  end
end
