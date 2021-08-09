require 'rails_helper'

RSpec.describe 'EditingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) do
    User.create(email: 'example@mail.com',
                password: 'password')
  end

  let(:category) do
    Category.create(title: 'Category Title',
                    description: 'Category Description',
                    user_id: user.id)
  end

  describe Task do
    let(:attributes) do
      {
        description: 'Task Description',
        priority: Date.today,
        user_id: user.id,
        category_id: category.id
      }
    end

    subject { described_class.create(attributes) }

    let(:click_edit) { find("a[href='/categories/#{category.id}/tasks/#{subject.id}/edit']").click }
    let(:click_update) { find('input[type="submit"]').click }

    context 'when user logged in' do
      before do
        sign_in user
        category
        subject
        visit category_path(category)
        click_edit
      end

      context 'when task was created within its category, with priority date was date today then it can be edited' do
        it 'goes to form' do
          expect(page).to have_current_path(edit_category_task_path(category, subject))
        end
      end

      context 'when all form fields were filled up with new inputs and submitted' do
        let(:date_tomorrow) { Date.tomorrow }

        let(:subject_find_edited) do
          Task.find_by(description: 'Task Description Edited',
                       priority: date_tomorrow)
        end

        before do
          fill_in 'Description', with: 'Task Description Edited'
          fill_in 'task[priority]', with: date_tomorrow
          click_update
        end

        it 'updates task' do
          expect(subject_find_edited).to_not eq nil
        end

        it 'redirects to its category' do
          expect(page).to have_current_path(category_path(category))
        end

        context 'when navigating under "Future Tasks"' do
          it 'shows updated task' do
            within('#future-wrap') { expect(page).to have_content(subject_find_edited.description) }
          end
        end
      end

      context 'when all form fields were filled up with blank inputs and submitted' do
        let(:subject_find) { Task.find_by(attributes) }

        before do
          fill_in 'Description', with: ''
          fill_in 'task[priority]', with: ''
          click_update
        end

        it 'does not update task' do
          expect(subject_find).to_not eq nil
        end

        it 'redirects back to form' do
          expect(page).to have_current_path(category_task_path(category, subject))
        end

        it 'raises error' do
          expect(page).to have_css('#form-error-wrap')
        end
      end
    end

    context 'when user not logged in' do
      before do
        category
        subject
        visit edit_category_task_path(category, subject)
      end

      it 'shows "not allowed" message' do
        expect(page).to have_content('not allowed')
      end
    end
  end
end
