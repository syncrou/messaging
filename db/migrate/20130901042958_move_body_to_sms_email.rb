class MoveBodyToSmsEmail < ActiveRecord::Migration
  def change
    add_column :sms, :body, :text
    add_column :emails, :body, :text
    remove_column :deliverables, :body
  end
end
