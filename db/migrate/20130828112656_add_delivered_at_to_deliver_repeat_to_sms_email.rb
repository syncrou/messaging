class AddDeliveredAtToDeliverRepeatToSmsEmail < ActiveRecord::Migration
  def change
    remove_column :deliverables, :delivered_at
    remove_column :deliverables, :to_deliver
    add_column :emails, :delivered_at, :datetime
    remove_column :deliverables, :type
    add_column :emails, :to_deliver, :datetime
    add_column :sms, :to_deliver, :datetime
    add_column :sms, :delivered_at, :datetime
    add_column :emails, :repeat, :integer
    add_column :sms, :repeat, :integer
  end
end
