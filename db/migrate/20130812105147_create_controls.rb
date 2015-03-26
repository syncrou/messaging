class CreateControls < ActiveRecord::Migration
  def change
    create_table :controls do |t|
      t.integer :customer_id
      t.string :name
      t.string :twilio_api

      t.timestamps
    end
  end
end
