require 'rails_helper'

RSpec.describe SessionsController do
  include Devise::TestHelpers

  let!(:user1) { create :user, username: "JeanMary", password: "PassWord", password_confirmation: "Password"}

  describe '#create' do
    context "good credentials" do
      subject(:call_method) do
        post :create, { params: { username: "JeanMary", password: "PassWord" }}
        JSON.parse(response.body, symbolize_names: true)
      end

      it do
        expect(subject[:auth_token]).to be
        expect(subject).not_to include :message
      end
    end

    context "wrong credentials" do
      subject(:call_method) do
        post :create, { params: { username: "JeanMary", password: "Wrong_PassWord" }}
        JSON.parse(response.body, symbolize_names: true)
      end

      it { expect(subject).not_to include :auth_token }
      it { expect(subject[:message]).to eql 'Unauthorized'}
    end

  end

end
