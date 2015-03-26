class ChangeCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :db_connection
  end
end
