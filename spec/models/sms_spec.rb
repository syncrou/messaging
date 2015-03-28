describe Sms do
  before(:all) do
    Accounting.delete_all
    Customer.delete_all
    Sms.delete_all
    Deliverable.delete_all
  end

  before(:each) do
    FactoryGirl.create :accounting
    FactoryGirl.create :customer
  end

  it "should print out to, from and body values when print_me! is called" do
    sms = Sms.new(name: 'EEEYY', customer_id: Customer.last.id, to_deliver: 1569875434, body: "blah blah", to_phone: 4569875434, accounting: Accounting.last)
    expect(sms.save).to eq true
    expect(Rails.logger).to receive(:debug).with "[sms#print_me!] SMS sent to: #{sms.deliverables.first.to} from: #{sms.deliverables.first.from} body: #{sms.body}"
    sms.print_me!
  end

end
