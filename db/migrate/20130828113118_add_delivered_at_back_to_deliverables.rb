class AddDeliveredAtBackToDeliverables < ActiveRecord::Migration
  def change
    add_column :deliverables, :delivered_at, :datetime
    remove_column :emails, :delivered_at
    remove_column :sms, :delivered_at
  end
end
