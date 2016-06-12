require 'feature/decision'

describe Feature::Decision, :type => :model do
  let(:name)     { "Bob" }
  let(:purpose)  { "Purpose" }
  let(:location) { "Location" }
  let(:approval) { "Approval" }
  let(:value)    { "Value" }

  describe ".new with no arguments" do
    subject { described_class.new }

    it("has a nil name")     { expect(subject.name).to     be_nil }
    it("has a nil purpose")  { expect(subject.purpose).to  be_nil }
    it("has a nil location") { expect(subject.location).to be_nil }
    it("has a nil approval") { expect(subject.approval).to be_nil }
    it("has a nil value")    { expect(subject.value).to    be_nil }
  end

  describe ".new with hash" do
    let(:init_hash) { {
      name:     name,
      purpose:  purpose,
      location: location,
      approval: approval,
      value:    value
    } }

    subject { described_class.new(init_hash) }

    it("has a name")     { expect(subject.name).to     eq(name) }
    it("has a purpose")  { expect(subject.purpose).to  eq(purpose) }
    it("has a location") { expect(subject.location).to eq(location) }
    it("has a approval") { expect(subject.approval).to eq(approval) }
    it("has a value")    { expect(subject.value).to    eq(value) }


  end

  describe "#merge" do
    subject { original_decision.merge(other_decision) }

    context "when no attributes are set in the merged decision" do

      let(:original_decision) { described_class.new(
        name:     name,
        purpose:  purpose,
        location: location,
        approval: approval,
        value:    value
      ) }

      let(:other_decision) { described_class.new(
        name:     nil,
        purpose:  nil,
        location: nil,
        approval: nil,
        value:    nil
      ) }

      it("doesn't change the name")     { expect(subject.name).to eq(name) }
      it("doesn't change the purpose")  { expect(subject.purpose).to eq(purpose) }
      it("doesn't change the location") { expect(subject.location).to eq(location) }
      it("doesn't change the approval") { expect(subject.approval).to eq(approval) }
      it("doesn't change the value")    { expect(subject.value).to eq(value) }
    end

    context "when merged decision has all attributes set" do
      subject { original_decision.merge(other_decision) }

      let(:original_decision) { described_class.new(
        name:     name,
        purpose:  purpose,
        location: location,
        approval: approval,
        value:    value
      ) }

      let(:other_decision) { described_class.new(
        name:     "Brian",
        purpose:  "Nefarious",
        location: "Bhutan",
        approval: "I approve this ad",
        value:    "Something else"
      ) }

      it("doesn't change the name")     { expect(subject.name).to eq("Brian") }
      it("doesn't change the purpose")  { expect(subject.purpose).to eq("Nefarious") }
      it("doesn't change the location") { expect(subject.location).to eq("Bhutan") }
      it("doesn't change the approval") { expect(subject.approval).to eq("I approve this ad") }
      it("doesn't change the value")    { expect(subject.value).to eq("Something else") }
    end
  end
end
