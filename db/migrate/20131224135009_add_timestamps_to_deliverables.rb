class AddTimestampsToDeliverables < ActiveRecord::Migration
  def change
    add_column :sms, :created_at, :datetime
    add_column :sms, :updated_at, :datetime
  end
end
