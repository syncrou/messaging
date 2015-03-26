class AddExtra5ToRules < ActiveRecord::Migration
  def change
    add_column :rules, :extra_var_5, :string
  end
end
