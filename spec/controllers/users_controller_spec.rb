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

    it { expect(subject[:address_line_1]).to eql '6 avenue victor hugo' }

    it { expect(subject[:dob]).to eql '1978-10-17' }
    it { expect(subject[:age]).to eql 38 }

  end

end
