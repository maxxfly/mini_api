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

  describe '#create' do
    context "perfect case" do
      subject(:call_method) do
        post :create, { params: { user_id: user1.id, account_number_from: "C" * 18, account_number_to: "D" * 18,
                                                     country_code_from: 'GBR', country_code_to: 'GBR',
                                                     amount_pennies: 123 }}

        JSON.parse(response.body, symbolize_names: true)
      end

      it do
        expect(subject[:account_number_from]).to eql "C" * 18
        expect(subject[:account_number_to]).to eql "D" * 18
        expect(subject[:country_code_from]).to eql 'GBR'
        expect(subject[:country_code_to]).to eql 'GBR'
        expect(subject[:amount_pennies]).to eql 123

        expect(Transfer.first.user_id).to eql user1.id

        expect(subject).not_to include :id
        expect(subject).not_to include :user_id

        expect(Transfer.all.count).to eql 1
      end
    end

    context "with errors" do
      subject(:call_method) do
        post :create, { params: { user_id: user1.id, account_number_from: "C" * 16, account_number_to: "D" * 20,
                                                     country_code_from: 'GB', country_code_to: 'GBRA' }}

        JSON.parse(response.body, symbolize_names: true)
      end

      it { expect(subject).to include :errors }

      it { expect(subject[:errors]).to include :account_number_from }
      it { expect(subject[:errors][:account_number_from].length).to eql 1}
      it { expect(subject[:errors][:account_number_from].first).to include "is the wrong length" }

      it { expect(subject[:errors]).to include :account_number_to }
      it { expect(subject[:errors][:account_number_from].length).to eql 1}
      it { expect(subject[:errors][:account_number_from].first).to include "is the wrong length" }

      it { expect(subject[:errors]).to include :country_code_from }
      it { expect(subject[:errors][:country_code_from].length).to eql 1}
      it { expect(subject[:errors][:country_code_from].first).to include "is the wrong length" }

      it { expect(subject[:errors]).to include :country_code_to }
      it { expect(subject[:errors][:country_code_to].length).to eql 1}
      it { expect(subject[:errors][:country_code_to].first).to include "is the wrong length" }

      it { expect(subject[:errors]).to include :amount_pennies }
      it { expect(subject[:errors][:amount_pennies].length).to eql 1}
      it { expect(subject[:errors][:amount_pennies].first).to include "is not a number" }
    end
  end

  describe '#update' do
    let!(:transfer) { create :transfer, user_id: user1.id }

    context "perfect case" do
      subject(:call_method) do
        patch :update, { params: { user_id: user1.id, id: transfer.id,
                                   account_number_from: "A" * 18 , account_number_to: "B" * 18 }}

        JSON.parse(response.body, symbolize_names: true)
      end

      it { expect(Transfer.count).to eql 1}
      it { expect(subject[:account_number_from]).to eql "A" * 18 }
      it { expect(subject[:account_number_to]).to eql  "B" * 18 }
    end
  end

  describe '#delete' do
    let!(:transfer) { create :transfer, user_id: user1.id }

    subject(:call_method) do
      delete :destroy, { params: { id: transfer.id, user_id: user1.id }}
      JSON.parse(response.body, symbolize_names: true)
    end

    it do
      expect(subject[:message]).to eql 'Deleted'
      expect(Transfer.all.count).to eql 0
    end
  end
end
