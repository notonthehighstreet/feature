rubyGemPipeline(
    cc_test_reporter_id: "e49ca3f818e9cbede3a06c766520c8dcb441a9e96f8a0e2ef0689d8cf0a18ed0",
    ruby_version: 3.0,
    testSteps: {
        sh "gem install bundler:2.2.33"
        sh "bundle install"
        sh "bundle exec rspec --format RspecJunitFormatter --out rspec.xml"
        junit "rspec.xml"
    }
)
