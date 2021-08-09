require 'rails_helper'

RSpec.describe "Sign In", type: :system do
  let :existing_user do
    User.create(
      email: 'existing.email@example.com',
      password: 'password'
    )
  end

  before :each do
    driven_by(:rack_test)
    visit new_user_registration_path
  end

  context "When visiting the 'sign up' page" do
    it { expect(current_path).to eq new_user_registration_path }
    it { expect(page).to have_text('Sign up') }
  end

  context 'With invalid input field values' do
    context 'With blank email and password' do
      before :each do
        click_button 'Sign up'
      end

      it { expect(page).to have_text("Email can't be blank") }
      it { expect(page).to have_text("Password can't be blank") }
      it { expect(page).to have_text("Encrypted password can't be blank") }
    end

    context 'With existing email' do
      it do
        existing_user
        fill_in 'Email', with: 'existing.email@example.com'
        click_button 'Sign up'
        expect(page).to have_text('Email has already been taken')
      end
    end

    context 'With short password' do
      it do
        fill_in 'Email', with: 'email@example.com'
        fill_in 'Password', with: 'a' * 5
        click_button 'Sign up'
        expect(page).to have_text('Password is too short (minimum is 6 characters)')
      end
    end

    context 'With no matching password and password confirmation' do
      it do
        fill_in 'Email', with: 'email@example.com'
        fill_in 'Password', with: 'a' * 6
        fill_in 'Password confirmation', with: 'a' * 7
        click_button 'Sign up'
        expect(page).to have_text("Password confirmation doesn't match Password")
      end
    end
  end

  context 'With valid input field values' do
    before :each do
      fill_in 'Email', with: 'unique.email@example.com'
      fill_in 'Password', with: 'a' * 6
      fill_in 'Password confirmation', with: 'a' * 6
      click_button 'Sign up'
    end

    it { expect(current_path).to eq root_path }
    it { expect(page).to have_text('Welcome! You have signed up successfully.') }
  end
end
