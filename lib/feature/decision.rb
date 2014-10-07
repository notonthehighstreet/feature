# -*- encoding : utf-8 -*-

module Feature
  class Decision
    attr_reader :name, :purpose, :location, :approval, :value

    def initialize(attrs={})
      @name     = attrs[:name]
      @purpose  = attrs[:purpose]
      @location = attrs[:location]
      @approval = attrs[:approval]
      @value    = attrs[:value]
    end

    def merge(other)
      return dup if other.nil?

      Decision.new(
        name:     merge_values(name, other.name),
        purpose:  merge_values(purpose, other.purpose),
        location: merge_values(location, other.location),
        approval: merge_values(approval, other.approval),
        value:    merge_values(value, other.value)
      )
    end

    def ==(other)
      contents_as_array == other.contents_as_array
    end

    def hash
      contents_as_array.hash
    end

    def id
      name
    end

    protected

    def contents_as_array
      [self.class, name, purpose, location, approval, value]
    end

    private

    def merge_values(my_value, other_value)
      other_value.nil? ? my_value : other_value
    end
  end
end
