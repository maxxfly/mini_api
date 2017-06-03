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

require 'rails_helper'

RSpec.describe Transfer, type: :model do
  subject { build(:transfer) }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:account_number_from) }
    it { is_expected.to validate_presence_of(:account_number_to) }
    it { is_expected.to validate_presence_of(:country_code_from) }
    it { is_expected.to validate_presence_of(:country_code_to) }

    it { is_expected.to validate_length_of(:account_number_from).is_equal_to(18) }
    it { is_expected.to validate_length_of(:account_number_to).is_equal_to(18) }
    it { is_expected.to validate_length_of(:country_code_from).is_equal_to(3) }
    it { is_expected.to validate_length_of(:country_code_to).is_equal_to(3) }

    it { is_expected.to validate_numericality_of(:amount_pennies).is_greater_than_or_equal_to(0) }

    it { is_expected.to belong_to(:user) }


  end

end
