# == Schema Information
#
# Table name: transfers
#
#  id                  :integer          not null, primary key
#  user_id             :integer          not null
#  account_number_from :string           not null
#  account_number_to   :string           not null
#  amount_pennies      :integer
#  country_code_from   :string           not null
#  country_code_to     :string           not null
#

class Transfer < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :account_number_from, presence: true, length: { is: 18 }
  validates :account_number_to, presence: true, length: { is: 18 }
  validates :amount_pennies, numericality: { greater_than_or_equal_to: 0 }
  validates :country_code_from, presence: true, length: { is: 3 }
  validates :country_code_to, presence: true, length: { is: 3 }


end
