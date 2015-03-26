# == Schema Information
#
# Table name: controls
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  friendly_name :string(255)
#

require 'yaml'
class Control < ActiveRecord::Base
  has_many :customers

# Create a list of all current connections
#  available in database.yml
  def self.connections
    YAML::load(File.read('config/database.yml'))
  end
end
