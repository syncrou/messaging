require 'factory_girl'

describe Deliverable do
  context "Validations" do
    it "validates to and to_deliver are unique" do
      FactoryGirl.create :customer
      FactoryGirl.create :accounting

      sms = Sms.new(name: 'EEEYY', customer_id: Customer.last.id, body: "blah blah", to_phone: 4569875434, accounting: Accounting.last)
      sms.save
    end
  end
end
