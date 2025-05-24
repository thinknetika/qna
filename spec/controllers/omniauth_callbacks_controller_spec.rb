require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  shared_examples_for 'oauth callback' do |provider|
    describe provider.capitalize do
      let(:oauth_data) { { 'provider' => provider, 'uid' => 123 } }
      let(:action) { provider }

      it 'finds user from oauth data' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get action
      end

      context 'user exists' do
        let!(:user) { create(:user) }

        before do
          allow(User).to receive(:find_for_oauth).and_return([user, 'password']) # Возвращаем массив
          get action
        end

        it 'login user' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist' do
        before do
          allow(User).to receive(:find_for_oauth).and_return([nil, 'password'])
          get action
        end

        it 'redirects to new user session path' do
          expect(response).to redirect_to new_user_session_path
          expect(flash[:alert]).to eq("Something went wrong")
        end

        it 'does not login user' do
          expect(subject.current_user).to be_nil
        end
      end
    end
  end

  shared_examples_for 'yandex oauth callback' do
    describe 'Yandex' do
      let(:oauth_data) { { 'provider' => 'yandex', 'uid' => 123, 'info' => { 'email' => email } } }
      let(:action) { :yandex }

      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      end

      context 'user exists with email' do
        let!(:user) { create(:user, email: 'test@example.com') }
        let(:email) { 'test@example.com' }

        before do
          allow(User).to receive(:find_for_oauth).and_return([user, 'password'])
          get action
        end

        it 'login user' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to edit user registration path' do
          expect(response).to redirect_to edit_user_registration_path
        end

        it 'sets temporary password in session' do
          expect(session[:temporary_password]).to eq('password')
        end
      end

      context 'user does not exist' do
        let(:email) { 'new@example.com' }

        before do
          allow(User).to receive(:find_for_oauth).and_return([nil, 'password'])
          get action
        end

        it 'redirects to new user registration path' do
          expect(response).to redirect_to new_user_registration_path
          expect(flash[:notice]).to eq("Authenticated failed")
        end

        it 'does not login user' do
          expect(subject.current_user).to be_nil
        end
      end
    end
  end

  it_behaves_like 'oauth callback', 'github'
  it_behaves_like 'oauth callback', 'google_oauth2'
  it_behaves_like 'yandex oauth callback'
end
