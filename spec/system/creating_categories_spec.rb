require 'rails_helper'

RSpec.describe 'CreatingCategories', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) do
    User.create(email: 'example@mail.com',
                password: 'password')
  end

  describe Category do
    subject do
      described_class.find_by(title: 'Category Title',
                              description: 'Category Description')
    end

    let(:subject_count) { Category.count }

    let(:click_new) { find('a[href="/categories/new"]').click }
    let(:click_create) { find('input[type="submit"]').click }

    context 'when user logged in' do
      before do
        sign_in user
        visit categories_path
        click_new
      end

      context 'when navigating in page of all categories then a category can be created' do
        it 'goes to form' do
          expect(page).to have_current_path(new_category_path)
        end

        it 'expects hidden field' do
          expect(find('input[type="hidden"]', visible: false).value).to eq(user.id.to_s)
        end
      end

      context 'when all form fields were filled up and submitted' do
        before do
          fill_in 'Title', with: 'Category Title'
          fill_in 'Description', with: 'Category Description'
          click_create
        end

        it 'creates a category' do
          expect(subject).to_not eq nil
          expect(subject_count).to eq 1
        end

        it 'redirects to created category' do
          expect(page).to have_current_path(category_path(subject))
        end

        it 'renders page with submitted inputs' do
          expect(page).to have_content(subject.title)
          expect(page).to have_content(subject.description)
        end
      end

      context 'when all form fields were not filled up and submitted' do
        before do
          click_create
        end

        it 'does not create a category' do
          expect(subject).to eq nil
          expect(subject_count).to eq 0
        end

        it 'redirects back to form' do
          expect(page).to have_current_path(categories_path)
        end

        it 'raises error' do
          expect(page).to have_css('#error-explanation')
        end
      end
    end

    context 'when user not logged in and trying to create a category through url' do
      before do
        visit new_category_path
      end

      it 'shows "sign in" message' do
        expect(page).to have_content('need to sign in')
      end
    end
  end
end
