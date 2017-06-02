# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  first_name     :string           not null
#  last_name      :string           not null
#  address_line_1 :string           not null
#  dob            :date             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class User < ActiveRecord::Base
  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :address_line_1, presence: true, length: { maximum: 50 }
  validates :dob, presence: true

end
