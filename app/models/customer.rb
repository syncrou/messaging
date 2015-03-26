# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  email_fee  :integer
#  sms_fee    :integer
#  send_sms   :boolean
#  send_email :boolean
#  control_id :integer
#  phone      :string(255)
#

class Customer < ActiveRecord::Base
  belongs_to :control
  has_many :deliverables
  has_many :accountings
  has_many :rules
end
