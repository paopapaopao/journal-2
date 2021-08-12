require 'rails_helper'

RSpec.describe 'ViewingCategories', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) do
    User.create(email: 'example@mail.com',
                password: 'password')
  end

  describe Category do
    subject do
      described_class.create(title: 'Category Title',
                             description: 'Category Description',
                             user_id: user.id)
    end

    context 'when navigating in page of all categories' do
      context 'when user logged in' do
        before do
          sign_in user
        end

        it 'shows heading' do
          visit categories_path
          expect(page).to have_content('Categories')
        end

        context 'when there are no categories yet' do
          before do
            visit categories_path
          end

          it 'shows "create" message' do
            expect(page).to have_content('Create a new category now!')
          end
        end

        context 'when a category was created' do
          let(:subject_title) { subject.title }
          let(:subject_description) { subject.description }

          before do
            subject
            visit categories_path
          end

          it 'shows created category' do
            expect(page).to have_content(subject_title)
            expect(page).to have_content(subject_description)
          end

          context 'when viewing that category created' do
            let(:click_show) { find("a[href='/categories/#{subject.id}']").click }

            before do
              click_show
            end

            it 'goes to the category' do
              expect(page).to have_current_path(category_path(subject))
            end

            it 'renders page with its contents' do
              expect(page).to have_content(subject_title)
              expect(page).to have_content(subject_description)
            end
          end
        end
      end

      context 'when user not logged in' do
        before do
          visit categories_path
        end

        it 'shows "please login" message' do
          expect(page).to have_content('Please log in')
        end

        context 'when trying to access a category through url' do
          before do
            visit category_path(subject)
          end

          it 'shows "sign in" message' do
            expect(page).to have_content('need to sign in')
          end
        end
      end
    end
  end
end
