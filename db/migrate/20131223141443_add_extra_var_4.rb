class AddExtraVar4 < ActiveRecord::Migration
  def change
    add_column :rules, :extra_var_4, :string
  end
end
