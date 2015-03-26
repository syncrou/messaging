class RemoveCustomerIdFromDeliverables < ActiveRecord::Migration
  def change
    remove_column :deliverables, :customer_id
  end
end
