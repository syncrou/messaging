# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  group_id   :string(255)
#  email      :string(255)
#  phone      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Contact < ActiveRecord::Base
end
