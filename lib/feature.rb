require 'ostruct'
require "feature/version"
require "feature/decision_set"
require "feature/public_decision_set"
require "feature/threshold_decision_set"
require "feature/always_false"

# -*- encoding : utf-8 -*-

# A feature is generally some individual bit of functionality which
# we may want to switch on and off in certain circumstances.  For example, we
# may have functionality around allowing people to store cards, allowing
# multiple currencies, showing different layouts, etc.
#
# We may want a feature around functionality for a number of different reasons:
#  - Stage rollout to production, so allow feature to be tested by specific
#    users or rolled out to specific slices of users before switching fully on.
#  - Allow for quick rollback in case it breaks when switched on.
#  - Allow for turning off if it performs poorly under load
#
# Feature configuration can be chained. By default it will look in the
# Feature.configuration object which can be set in a Rails initializer.
#
# Currently, it's either just true or false, but ideally we'd like to make the
# following extensions:
#  - Give the option for non-truthy values (so maybe we have three versions of
#    a feature which can be switched between)
#  - Store features in database, or allow for some other override mechanism
#    where features can be globally switched on or off without requiring a
#    deploy.
#
# The majority of the implementation refers to a specific feature being set as
# a Decision.  So stored_cards: false and stored_cards: true are two seperate
# "decisions".  This is very loose and needs better definition and
# documentation around it.
#
module Feature
  class << self

    # A feature "chain" is the concept by which we can (for example) chain
    # different methods of setting a decision. For example, we may take
    # AppConfig settings as a baseline, but then chain overrides from a cookie
    # onto that, so that if there's no cookie value we'll take a config.
    #
    # TODO: make a bit clearer...
    attr_accessor :chain

    def enabled?(name)
      if chain.present?
        chain.enabled?(name)
      else
        configuration.features.fetch(name.to_sym)
      end
    end

    def all
      if chain.present?
        chain.all
      else
        []
      end
    end

    def all_with_enabled
      all.inject({}) { |collector, item| collector.tap { collector[item.name] = item.value } }
    end

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= ::OpenStruct.new(
        whitelist: [],
        abbreviations: {},
        features: {},
        feature_thresholds: {}
      )
    end
  end
end
