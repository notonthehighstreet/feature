require 'active_support/core_ext/hash/indifferent_access'

module Feature

  # A ThresholdDecisionSet allows us to segment traffic for a feature, so we can
  # have (e.g.) category filters in the search page for 10% of traffic. In order
  # to use this, simply set up the following in features.yml:
  #
  # feature_thresholds:
  #   search_category_filters: 0.1
  #
  # Where the 0.1 represents the 10% of people who will get "true" for this
  # feature.
  class ThresholdDecisionSet < DecisionSet

    def self.build(data)
      if data.is_a?(Hash)
        raise InvalidHashProvided if data.has_key?(:feature_thresholds)
        parsed_data = HashWithIndifferentAccess.new({
          "features" => (data || {}),
          "feature_thresholds" => Feature.configuration.feature_thresholds
        })
      else
        parsed_data = JSON.parse(data || '{"features": {}, "feature_thresholds": {}}')

        # This is just for safety because we've changed the structure of the
        # hash stored in the "features" cookie.  This can be removed once it's
        # bedded in.
        unless parsed_data.has_key?("features")
          parsed_data = HashWithIndifferentAccess.new({
            "features" => parsed_data,
            "feature_thresholds" => {}
          })
        end
      end

      features = parsed_data["features"]
      thresholds = parsed_data["feature_thresholds"]

      valid_features = filter_out_redundant_features(features, thresholds)
      valid_features = apply_thresholds_to(valid_features)

      self.new(valid_features)
    end

    def to_json
      {
        features: features_as_hash,
        feature_thresholds: Feature.configuration.feature_thresholds
      }.to_json
    end

    # Remove redundant feature, so if:
    #   - feature thresholds are no longer in place for this feature (so fully on or off)
    #   - threshold has changed, in which case remove it in order to recalculate
    #     WARNING: This may cause user experience to vary, so do this infrequently!
    def self.filter_out_redundant_features(features, thresholds)
      features.reject do |feature, value|
        Feature.configuration.feature_thresholds[feature.to_sym].nil? ||
          Feature.configuration.feature_thresholds[feature.to_sym] != thresholds[feature]
      end
    end
    private_class_method :filter_out_redundant_features

    def self.apply_thresholds_to(features)
      processed_features = {}

      Feature.configuration.feature_thresholds.each do |key, threshold|
        value = rand < threshold
        value = features[key.to_s] if features.has_key?(key.to_s) # we should keep the previous value
        processed_features[key.to_s] = value
      end

      processed_features
    end
    private_class_method :apply_thresholds_to
  end

  class InvalidHashProvided < StandardError ; end

end
