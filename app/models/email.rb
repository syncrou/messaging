# == Schema Information
#
# Table name: emails
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  customer_id :integer
#  to_deliver  :datetime
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#  repeat      :integer
#  subject     :string(255)
#

class Email < ActiveRecord::Base
  attr_accessor :accounting, :to_email

  SEND_TIME_DIFFERENCE = 60

  has_many :deliverables, as: :sendable
  belongs_to :customer

  before_save :to_deliverable

  scope :undelivered, -> { includes(:deliverables).where("deliverables.delivered_at IS NULL").references(:deliverables) }

  def send_me!
    ActionMailer::Base.smtp_settings = set_smtp
    Emailer.send_email(deliverables.first.from, deliverables.first.to, subject, body).deliver
    deliverables.first.update_attributes(:delivered_at => Time.now)
  end

  def send_me_test!
    Rails.logger.debug "[email#send_me_test!] test_email: #{app_config.test_email["send_to"]} sent to: #{deliverables.first.to} from: #{deliverables.first.from} subject: #{subject} body: #{body}"
    ActionMailer::Base.smtp_settings = set_smtp
    Emailer.send_email(deliverables.first.from, app_config.test_email["send_to"], subject, body).deliver
    deliverables.first.update_attributes(:delivered_at => Time.now)
  end

  private

  # Determine what deliverables are set for this email batch
  #
  # * Save the deliverable data to the deliverables table

  def to_deliverable
    deliver = Deliverable.new(:to => @to_email,
                              :from => customer.email,
                              :accounting_id => @accounting.id,
                              :cents => 0,
                              :to_deliver => to_deliver)
    return false unless deliver.valid?
    deliverables << deliver
    true
  end

  def set_smtp
    app_config.send("#{customer.control.name}_email".to_sym)
  end
end
