class ChangeDeliverAtToString < ActiveRecord::Migration
  def change
    change_column :rules, :deliver_at, :string
  end
end
