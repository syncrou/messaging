class CreateEmail < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :name
      t.integer :customer_id
    end
    create_table :sms do |t|
      t.string :name
      t.integer :customer_id
    end
  end
end
