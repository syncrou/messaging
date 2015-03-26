class AddCentsUpdatedAtCreatedAtToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :created_at, :datetime
    add_column :emails, :updated_at, :datetime
    add_column :emails, :repeat, :integer
    remove_column :sms, :cents
  end
end
