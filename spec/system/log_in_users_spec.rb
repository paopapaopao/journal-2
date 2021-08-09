require 'rails_helper'

RSpec.describe "Log In", type: :system do
  let :user do
    User.create(
      email: 'email@example.com',
      password: 'password'
    )
  end

  before :each do
    driven_by(:rack_test)
    visit new_user_session_path
  end

  context "When visiting the 'sign in' page" do
    it { expect(current_path).to eq new_user_session_path }
    it { expect(page).to have_text('Log in') }
  end

  context 'With invalid input field values' do
    context 'With blank email and password' do
      it do
        click_button 'Log in'
        expect(page).to have_text('Invalid Email or password.')
      end
    end

    context 'With invalid email' do
      it do
        user
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password1'
        click_button 'Log in'
        expect(page).to have_text('Invalid Email or password.')
      end
    end

    context 'With invalid password' do
      it do
        user
        fill_in 'Email', with: 'incorrect@example.com'
        fill_in 'Password', with: user.password
        click_button 'Log in'
        expect(page).to have_text('Invalid Email or password.')
      end
    end
  end

  context 'With valid input field values' do
    before :each do
      User.destroy_all
      user
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end

    it { expect(current_path).to eq root_path }
    it { expect(page).to have_text('Signed in successfully.') }
  end

  context 'When Forgot your password? is clicked' do
    before(:each) { visit new_user_password_path }

    it { expect(page).to have_text('Forgot your password?') }
    it { expect(current_path).to eq new_user_password_path }
  end
end
