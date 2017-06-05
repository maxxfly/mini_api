require 'rails_helper'

RSpec.describe TransfersController do
  let!(:user1) { create :user, first_name: 'JeanMary', last_name: 'LECOUTEUX', address_line_1: '6 avenue victor hugo', dob: '1978-10-17'}
  let!(:user2) { create :user, first_name: 'Barnabe', last_name: 'Smith', address_line_1: '6 avenue victor hugo', dob: '1980-01-01'}

  describe '#index' do
    let!(:transfer) { create :transfer, user_id: user1.id }

    context "user has transfers" do
      subject(:call_method) do
        get :index, { params: { user_id: user1.id }}
        JSON.parse(response.body, symbolize_names: true)
      end

      it { expect(subject.count).to eql 1}
      it { expect(subject.first[:account_number_from]).to eql transfer.account_number_from }
      it { expect(subject.first[:account_number_to]).to eql transfer.account_number_to }
      it { expect(subject.first[:amount_pennies]).to eql transfer.amount_pennies }
      it { expect(subject.first[:country_code_from]).to eql transfer.country_code_from }
      it { expect(subject.first[:country_code_to]).to eql transfer.country_code_to }

      it { expect(subject.first).not_to include :id }
      it { expect(subject.first).not_to include :user_id }
    end

    context "user has not transfers" do
      subject(:call_method) do
        get :index, { params: { user_id: user2.id }}
        JSON.parse(response.body, symbolize_names: true)
      end

      it { expect(subject.count).to eql 0}
    end

    context "user doesn't exist" do
      subject(:call_method) do
        get :index, { params: { user_id: user2.id + 1 }}
        JSON.parse(response.body, symbolize_names: true)
      end

      it { expect(subject[:message]).to eql 'User not found' }
    end
  end

  describe '#show' do
    let!(:transfer) { create :transfer, user_id: user1.id }

    context "known transfer for this user" do
      subject(:call_method) do
        get :show, { params: { user_id: user1.id, id: transfer.id }}
        JSON.parse(response.body, symbolize_names: true)
      end

      it { expect(subject[:account_number_from]).to eql transfer.account_number_from }
      it { expect(subject[:account_number_to]).to eql transfer.account_number_to }
      it { expect(subject[:amount_pennies]).to eql transfer.amount_pennies }
      it { expect(subject[:country_code_from]).to eql transfer.country_code_from }
      it { expect(subject[:country_code_to]).to eql transfer.country_code_to }

      it { expect(subject).not_to include :id }
      it { expect(subject).not_to include :user_id }
    end

    context "unknow transfor for this user" do
      subject(:call_method) do
        get :show, { params: { user_id: user2.id, id: transfer.id }}
        JSON.parse(response.body, symbolize_names: true)
      end

      it { expect(subject[:message]).to eql 'Transfer not found' }

    end

  end
end
