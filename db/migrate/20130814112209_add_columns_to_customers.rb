class AddColumnsToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :email_fee, :integer
    add_column :customers, :sms_fee, :integer
    add_column :customers, :send_sms, :boolean
    add_column :customers, :send_email, :boolean
  end
end
