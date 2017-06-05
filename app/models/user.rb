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
  has_many :transfers

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :address_line_1, presence: true, length: { maximum: 50 }
  validates :dob, presence: true
  validates :username, uniqueness: true

  devise :database_authenticatable, :token_authenticatable

  def age
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def generate_token
    loop do
      @token = Devise.friendly_token
      break self.authentication_token = @token unless User.find_by_authentication_token(@token)
    end

    self.save
  end

  def as_json(options={})
    { name: first_name + " " + last_name,
      first_name: first_name,
      last_name: last_name,
      address_line_1: address_line_1,
      dob: dob,
      age: age

    }
  end

end
