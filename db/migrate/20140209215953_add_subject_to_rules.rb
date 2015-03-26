class AddSubjectToRules < ActiveRecord::Migration
  def change
    add_column :rules, :subject, :string
    add_column :emails, :subject, :string
  end
end
