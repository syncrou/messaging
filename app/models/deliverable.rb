# == Schema Information
#
# Table name: deliverables
#
#  id            :integer          not null, primary key
#  to            :string(255)
#  from          :string(255)
#  cents         :integer
#  accounting_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#  sendable_id   :integer
#  sendable_type :string(255)
#  delivered_at  :datetime
#

class Deliverable < ActiveRecord::Base
  attr_accessor :to_deliver

  belongs_to :accounting
  belongs_to :sendable, polymorphic: true

  validates_presence_of :to, :from, :cents, :accounting_id
  validate :to_and_to_deliver_are_unique, :on => :create

  validates_length_of :to, is: 10, if: Proc.new { |x| x.is_a?(Sms) }
  validates_length_of :from, is: 10, if: Proc.new { |x| x.is_a?(Sms) }

  private

  def to_and_to_deliver_are_unique
    if self.class.exists?(to: to)
      errors.add(:base, 'to_deliver is not unique for this to number') if to_deliver_not_unique?
    end
  end

  # Determine if we already have a deliverable with the same
  #   to_deliver and to number saved already
  #
  # * Grab a list of existing sendable_ids for this to number
  # * Find all sms's in that list where we have the same to_deliver

  def to_deliver_not_unique?
    list = self.class.where(to: to).map { |x| x.sendable_id }
    deliver = Sms.where(:id => [list], :to_deliver => to_deliver)
    return true if deliver.size > 0
    false
  end
end
