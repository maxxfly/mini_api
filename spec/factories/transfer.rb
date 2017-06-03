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

require 'faker'

FactoryGirl.define do
  factory :transfer do
    user_id { create :user }
    account_number_from '000123456789ABCDEF'
    account_number_to 'FEDCBA987654321000'
    amount_pennies { Faker::Commerce.price }
    country_code_from 'GBR'
    country_code_to 'GBR'

  end
end
