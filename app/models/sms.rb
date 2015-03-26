# == Schema Information
#
# Table name: sms
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  customer_id :integer
#  to_deliver  :datetime
#  repeat      :integer
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#

# == Schema Information
#
# Table name: sms
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  customer_id :integer
#  to_deliver  :datetime
#  repeat      :integer
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#
require 'twilio-ruby'

class Sms < ActiveRecord::Base
  attr_accessor :accounting, :to_phone

  SEND_TIME_DIFFERENCE = 60

  has_many :deliverables, as: :sendable
  belongs_to :customer

  validates_length_of :body, :maximum => 160

  before_save :to_deliverable

  scope :undelivered, -> { includes(:deliverables).where("deliverables.delivered_at IS NULL AND deliverables.to != 0").references(:deliverables) }

  def send_me!
    sid = set_sid
    token = set_token

    @client ||= Twilio::REST::Client.new(sid, token)
    @client.account.messages.create(
      :from => deliverables.first.from,
      :to => deliverables.first.to,
      :body => body
    )
    deliverables.first.update_attributes(:delivered_at => Time.now)
  end

  def print_me!
    Rails.logger.debug "[sms#print_me!] SMS sent to: #{deliverables.first.to} from: #{deliverables.first.from} body: #{body}"
  end

  private

  # Determine what deliverables are set for this sms batch
  #
  # * Save the deliverable data to the deliverables table

  def to_deliverable
    deliver = Deliverable.new(:to => @to_phone.to_i,
                              :from => customer.phone,
                              :accounting_id => @accounting.id,
                              :cents => 1,
                              :to_deliver => to_deliver)
    return false unless deliver.valid?
    deliverables << deliver
    true
  end

  def set_sid
    app_config.send(customer.control.name.to_sym)["twilio_sid"]
  end

  def set_token
    app_config.send(customer.control.name.to_sym)["twilio_token"]
  end
end
