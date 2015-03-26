class RemoveTwilioFromControls < ActiveRecord::Migration
  def change
    remove_column :customers, :twilio_api, :string
  end
end
