require 'factory_girl'

describe Deliverable do
  before(:all) do
    Accounting.delete_all
    Customer.delete_all
    Sms.delete_all
    Deliverable.delete_all
  end

  context "Validations" do
    it "validates to and from phone numbers are unique" do
      FactoryGirl.create :customer
      FactoryGirl.create :accounting

      sms = Sms.new(name: 'EEEYY', customer_id: Customer.last.id, to_deliver: 7653459889, body: "blah blah", to_phone: 4569875434, accounting: Accounting.last)
      expect(sms.valid?).to eq true
      expect(sms.save).to eq true
    end

    it "fails validation if the to and from phone numbers are unique" do
      FactoryGirl.create :customer
      FactoryGirl.create :accounting

      sms = Sms.new(name: 'EEEYY', customer_id: Customer.last.id, to_deliver: 4569875434, body: "blah blah", to_phone: 4569875434, accounting: Accounting.last)
      expect(sms.valid?).to eq true
      expect(sms.save).to eq false
    end
  end
end
