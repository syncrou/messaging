class CreateAccountings < ActiveRecord::Migration
  def change
    create_table :accountings do |t|
      t.integer :customer_id
      t.decimal :invoiced
      t.decimal :paid

      t.timestamps
    end
  end
end
