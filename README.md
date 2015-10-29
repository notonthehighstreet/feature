# Feature

Feature flag support. For turning your application's features off and on again.

## Installation

Add this line to your application's Gemfile:

    gem 'feature'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install feature

## Usage

`Feature` can be configured using your applications initialization block:

```@ruby
Feature.configure do |config|
  config.features = YourFeatureHash || {}
  config.feature_thresholds = YourFeatureThresholdHash || {}
  config.whitelist = YourWhitelistArray || []
  config.abbreviations = YourAbbreviationHash || {}
end
```

### Features

The main usage of `Feature` is after setting `features` in the config block, `enabled?` can be used to check the boolean state of any feature. This is augmented in several ways:

### Feature thresholds

Feature thresholds allows us to segment traffic for a feature, so we can have (e.g.) category filters in the search page for 10% of traffic. In order to use this, simply set the following in feature_thresholds: `{search_category_filters: 0.1}`. The 0.1 represents the 10% of people who will get "true" for this feature.

### Whitelist

Whitelist is fairly straighforward; This is an array of features that can be configured and overridden separately to normal features. This is done with the aim of supporting parameter overrides of particular features.

### Abbreviations

Abbreviations simply allow for a simpler way to reference long feature keys; for example you might set it to `{longkey: ludicrously_over_needed_giant_key_example_yo}` to allow for easier use.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/feature/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
