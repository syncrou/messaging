FactoryGirl.define do
  factory :customer do |c|
    c.name "Test Customer"
    c.email_fee 0.01
    c.sms_fee 0.001
    c.send_sms 1
    c.send_email 1
    c.control_id 1
    c.phone "8764563498"
  end
end
