class AddDeliverAtToRules < ActiveRecord::Migration
  def change
    add_column :rules, :deliver_at, :time
  end
end
