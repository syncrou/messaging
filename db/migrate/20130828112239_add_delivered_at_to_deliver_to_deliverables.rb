class AddDeliveredAtToDeliverToDeliverables < ActiveRecord::Migration
  def change
    add_column :deliverables, :delivered_at, :datetime
    add_column :deliverables, :to_deliver, :datetime
  end
end
