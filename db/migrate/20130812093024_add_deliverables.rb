class AddDeliverables < ActiveRecord::Migration
  def change
    create_table :deliverables do |t|
      t.belongs_to :customer
      t.string :to
      t.string :from
      t.text :body
      t.string :type
      t.integer :cents
      t.belongs_to :accounting

      t.timestamps
    end
  end
end
