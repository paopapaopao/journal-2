require 'rails_helper'

RSpec.describe 'EditingCategories', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) do
    User.create(email: 'example@mail.com',
                password: 'password')
  end

  describe Category do
    let(:attributes) do
      {
        title: 'Category Title',
        description: 'Category Description',
        user_id: user.id
      }
    end

    subject { described_class.create(attributes) }

    let(:click_edit) { find("a[href='/categories/#{subject.id}/edit']").click }
    let(:click_update) { find('input[type="submit"]').click }

    context 'when user logged in' do
      before do
        sign_in user
        subject
        visit category_path(subject)
        click_edit
      end

      context 'when category was created it redirects to itself then it can be edited' do
        it 'goes to form' do
          expect(page).to have_current_path(edit_category_path(subject))
        end
      end

      context 'when all form fields were filled up with new inputs and submitted' do
        let(:subject_find_edited) do
          Category.find_by(title: 'Category Title Edited',
                           description: 'Category Description Edited')
        end

        before do
          fill_in 'Title', with: 'Category Title Edited'
          fill_in 'Description', with: 'Category Description Edited'
          click_update
        end

        it 'updates category' do
          expect(subject_find_edited).to_not eq nil
        end

        it 'redirects to updated category' do
          expect(page).to have_current_path(category_path(subject))
        end

        it 'renders page with submitted inputs' do
          expect(page).to have_content(subject_find_edited.title)
          expect(page).to have_content(subject_find_edited.description)
        end
      end

      context 'when all form fields are filled up with blank inputs and submitted' do
        let(:subject_find) { Category.find_by(attributes) }

        before do
          fill_in 'Title', with: ''
          fill_in 'Description', with: ''
          click_update
        end

        it 'does not update category' do
          expect(subject_find).to_not eq nil
        end

        it 'redirects back to form' do
          expect(page).to have_current_path(category_path(subject))
        end

        it 'raises error' do
          expect(page).to have_css('#error-explanation')
        end
      end
    end

    context 'when user not logged in and trying to access edit a category through url' do
      before do
        visit edit_category_path(subject)
      end

      it 'shows "sign in" message' do
        expect(page).to have_content('need to sign in')
      end
    end
  end
end
