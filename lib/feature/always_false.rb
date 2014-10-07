require 'singleton'

module Feature
  class AlwaysFalse < DecisionSet
    include ::Singleton

    def knows?(feature_key)
      true
    end

    def value(feature_key)
      false
    end

    def all
      []
    end

    protected

    def successor
      nil
    end
  end
end
