class ChangeControl < ActiveRecord::Migration
  def change
    remove_column :controls, :twilio_api
    add_column :controls, :friendly_name, :string
    add_column :customers, :twilio_api, :string
  end
end
