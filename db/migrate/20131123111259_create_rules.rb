class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.text :rule
      t.text :rule_body
      t.string :extra_var_1
      t.string :extra_var_2
      t.string :extra_var_3
      t.integer :customer_id
      t.string :name
      t.string :rule_type

      t.timestamps
    end
  end
end
