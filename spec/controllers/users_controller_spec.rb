require 'rails_helper'

RSpec.describe UsersController do
  describe '#index' do
    let!(:user) { create :user, first_name: 'JeanMary', last_name: 'LECOUTEUX', address_line_1: '6 avenue victor hugo', dob: '1978-10-17'}

    before do
      # Fix the time for the test about the age still OK
      t = Time.local(2017, 1, 1, 0, 0, 0)
      Timecop.travel(t)
    end

    subject(:call_method) do
      get :index
      JSON.parse(response.body, symbolize_names: true)
    end

    it { expect(subject.count).to eql 1}
    it { expect(subject.first[:first_name]).to eql 'JeanMary' }
    it { expect(subject.first[:last_name]).to eql 'LECOUTEUX' }
    it { expect(subject.first[:name]).to eql 'JeanMary LECOUTEUX' }
    it { expect(subject.first).not_to include :id }

    it { expect(subject.first[:address_line_1]).to eql '6 avenue victor hugo' }

    it { expect(subject.first[:dob]).to eql '1978-10-17' }
    it { expect(subject.first[:age]).to eql 38 }

  end

  describe '#get' do
    let!(:user) { create :user, first_name: 'JeanMary', last_name: 'LECOUTEUX', address_line_1: '6 avenue victor hugo', dob: '1978-10-17'}

    before do
      # Fix the time for the test about the age still OK
      t = Time.local(2017, 1, 1, 0, 0, 0)
      Timecop.travel(t)
    end

    subject(:call_method) do
      get :show, { params: { id: user.id }}
      JSON.parse(response.body, symbolize_names: true)
    end

    it { expect(subject[:first_name]).to eql 'JeanMary' }
    it { expect(subject[:last_name]).to eql 'LECOUTEUX' }
    it { expect(subject[:name]).to eql 'JeanMary LECOUTEUX' }
    it { expect(subject).not_to include :id }

    it { expect(subject[:address_line_1]).to eql '6 avenue victor hugo' }

    it { expect(subject[:dob]).to eql '1978-10-17' }
    it { expect(subject[:age]).to eql 38 }

  end

  describe '#destroy' do
    let!(:user) { create :user, first_name: 'JeanMary', last_name: 'LECOUTEUX', address_line_1: '6 avenue victor hugo', dob: '1978-10-17'}

    subject(:call_method) do
      delete :destroy, { params: { id: user.id }}
      JSON.parse(response.body, symbolize_names: true)
    end

    it do
      expect(subject[:message]).to eql 'Deleted'
      expect(User.all.count).to eql 0
    end
  end

  describe '#create' do
    context "perfect case" do
      before do
        # Fix the time for the test about the age still OK
        t = Time.local(2017, 1, 1, 0, 0, 0)
        Timecop.travel(t)
      end

      subject(:call_method) do
        post :create, { params: { first_name: "JeanMary", last_name: 'LECOUTEUX', address_line_1: '6 av. victor hugo', dob: '1978-10-17' }}
        JSON.parse(response.body, symbolize_names: true)
      end

      it do
        expect(subject[:first_name]).to eql 'JeanMary'
        expect(subject[:last_name]).to eql 'LECOUTEUX'
        expect(subject[:name]).to eql 'JeanMary LECOUTEUX'
        expect(subject).not_to include :id

        expect(subject[:address_line_1]).to eql '6 av. victor hugo'

        expect(subject[:dob]).to eql '1978-10-17'
        expect(subject[:age]).to eql 38

        expect(User.all.count).to eql 1
      end
    end

    context "with errors" do
      subject(:call_method) do
        post :create, { params: { first_name: "A" * 50, last_name: "A" * 50, address_line_1: "A" * 70 }}
        JSON.parse(response.body, symbolize_names: true)
      end

      it { expect(subject).to include :errors }
      it { expect(subject[:errors]).to include :first_name }
      it { expect(subject[:errors][:first_name].length).to eql 1}
      it { expect(subject[:errors][:first_name].first).to include "too long" }

      it { expect(subject[:errors]).to include :last_name }
      it { expect(subject[:errors][:last_name].length).to eql 1}
      it { expect(subject[:errors][:last_name].first).to include "too long" }

      it { expect(subject[:errors]).to include :address_line_1 }
      it { expect(subject[:errors][:address_line_1].length).to eql 1}
      it { expect(subject[:errors][:address_line_1].first).to include "too long" }


      it { expect(subject[:errors]).to include :dob }
      it { expect(subject[:errors][:dob].length).to eql 1}
      it { expect(subject[:errors][:dob].first).to include "can't be blank" }


    end
  end

end
