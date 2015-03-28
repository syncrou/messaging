require 'factory_girl'

describe Deliverable do
  before(:all) do
    Accounting.delete_all
    Customer.delete_all
    Sms.delete_all
    Deliverable.delete_all
  end

  before(:each) do
    FactoryGirl.create :customer
    FactoryGirl.create :accounting
  end

  context "Validations" do
    it "validates to and from phone numbers are unique" do

      sms = Sms.new(name: 'EEEYY', customer_id: Customer.last.id, to_deliver: 7653459889, body: "blah blah", to_phone: 4569875434, accounting: Accounting.last)
      expect(sms.valid?).to eq true
      expect(sms.save).to eq true
    end

    it "fails validation if the to and from phone numbers are unique" do
      sms = Sms.new(name: 'EEEYY', customer_id: Customer.last.id, to_deliver: 4569875434, body: "blah blah", to_phone: 4569875434, accounting: Accounting.last)
      expect(sms.valid?).to eq true
      expect(sms.save).to eq false
    end

    it "will not be valid if the to phone number is under 10 characters" do
      sms = Sms.new(name: 'EEEYY', customer_id: Customer.last.id, to_deliver: 1569875434, body: "blah blah", to_phone: 4569875434, accounting: Accounting.last)
      sms.save
      d = Deliverable.new(to: 234, from: 1234568734, cents: 1, accounting_id: 1, sendable_id: Sms.last.id, sendable_type: 'Sms')
      expect(d.save).to eq false
    end

    it "will not be valid if from to phone number is under 10 characters" do
      sms = Sms.new(name: 'EEEYY', customer_id: Customer.last.id, to_deliver: 1569875434, body: "blah blah", to_phone: 4569875434, accounting: Accounting.last)
      sms.save
      d = Deliverable.new(from: 234, to: 1234568734, cents: 1, accounting_id: 1, sendable_id: Sms.last.id, sendable_type: 'Sms')
      expect(d.save).to eq false
    end
  end
end
