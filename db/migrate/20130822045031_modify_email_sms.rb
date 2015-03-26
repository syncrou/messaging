class ModifyEmailSms < ActiveRecord::Migration
  def change
    add_column "deliverables", "sendable_id", "integer"
    add_column "deliverables", "sendable_type", "string"
    remove_column :controls, :customer_id
    add_column :customers, :control_id, :integer
  end
end
