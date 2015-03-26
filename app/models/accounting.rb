# == Schema Information
#
# Table name: accountings
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  invoiced    :integer
#  paid        :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Accounting < ActiveRecord::Base
  belongs_to :customer
  has_many :deliverables
end
