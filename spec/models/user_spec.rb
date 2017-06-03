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

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:address_line_1) }
    it { is_expected.to validate_presence_of(:dob) }

    it { is_expected.to validate_length_of(:first_name).is_at_most(20) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(20) }
    it { is_expected.to validate_length_of(:address_line_1).is_at_most(50) }

    it { is_expected.to have_many(:transfers) }

  end

end
