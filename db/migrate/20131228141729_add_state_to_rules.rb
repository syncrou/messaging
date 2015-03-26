class AddStateToRules < ActiveRecord::Migration
  def change
    add_column :rules, :state, :string
  end
end
