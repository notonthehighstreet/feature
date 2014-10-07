require_relative 'decision'

module Feature
  class DecisionSet

    def self.build(*features)
      source = {}
      features.each do |feature|
        source.merge!(feature.is_a?(Hash) ? feature : JSON.parse(feature || "{}"))
      end

      self.new(source)
    end


    def initialize(features = {})
      @decisions = generate_index(
        features.map { |key, value| Decision.new({name: key.to_s, value: value}) }
      )
    end

    def enabled?(feature_key)
      if knows?(feature_key)
        value(feature_key)
      else
        successor.enabled?(feature_key)
      end
    end

    def all
      return decisions.values unless @successor
      map_all(successor.all)
    end

    def ==(other)
      decisions == other.decisions && successor == other.successor
    end

    def hash
      [decisions, successor].hash
    end

    def chain(new_successor)
      if @successor.nil?
        @successor = new_successor
      else
        successor.chain(new_successor)
      end

      self
    end

    def to_json
      features_as_hash.to_json
    end

    protected

    attr_reader :decisions

    def knows?(key)
      decisions.has_key?(key.to_sym)
    end

    def value(key)
      decisions[key.to_sym].value
    end

    def map_all(successor_all)
      successor_all.map do |successor_decision|
        successor_decision.merge(decisions[successor_decision.name.to_sym])
      end
    end

    def successor
      @successor || AlwaysFalse.instance
    end

    private

    def features_as_hash
      all.inject( {} ) do |all_features, decision|
        all_features[decision.name.to_sym] = decision.value
        all_features
      end
    end

    def generate_index(decisions)
      Hash[decisions.map { |d| [d.name.to_sym, d] } ]
    end
  end
end
