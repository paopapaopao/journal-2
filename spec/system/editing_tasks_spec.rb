require 'rails_helper'

RSpec.describe 'EditingTasks', type: :system do
  before do
    driven_by(:rack_test)
    category
  end

  let(:category) { Category.create(title: 'Category Title', description: 'Category Description') }

  describe Task do
    let(:attributes) do
      {
        description: 'Task Description',
        priority: Date.today,
        category_id: category.id
      }
    end

    subject { described_class.create(attributes) }
    let(:subject_find) { Task.find_by(attributes) }
    let(:subject_find_edited) { Task.find_by(description: 'Task Description Edited') }

    let(:click_edit) { find("a[href='/categories/#{category.id}/tasks/#{subject.id}/edit']").click }

    before do
      subject
      visit category_path(category)
      click_edit
    end

    context 'when task was created within its category, with priority date was date today then it can be edited' do
      it 'goes to form' do
        expect(page).to have_current_path(edit_category_task_path(category, subject))
      end
    end

    context 'when all form fields were filled up with new inputs and submitted with priority date was date tomorrow' do
      let(:date_tomorrow) { Date.tomorrow }

      before do
        fill_in 'Description', with: 'Task Description Edited'
        fill_in 'task[priority]', with: date_tomorrow
        click_on 'Update Task'
      end

      it 'updates task' do
        expect(subject_find_edited.details).to eq('Task Description Edited')
        expect(subject_find_edited.priority).to eq(date_tomorrow)
      end

      it 'redirects to its category' do
        expect(page).to have_current_path(category_path(category))
      end

      context 'when navigating under "Future Tasks"' do
        it 'shows updated task' do
          within('#future-wrap') { expect(page).to have_content('Task Description Edited') }
        end
      end
    end

    context 'when all form fields were filled up with blank inputs and submitted' do
      before do
        fill_in 'Description', with: ''
        fill_in 'task[priority]', with: ''
        click_on 'Update Task'
      end

      it 'does not update task' do
        expect(subject_find.details).to eq('Task Description')
        expect(subject_find.priority).to eq(Date.today)
      end

      it 'redirects back to form' do
        expect(page).to have_current_path(category_task_path(category, subject))
      end

      context 'with description blank' do
        it 'raises an error' do
          expect(page).to have_content('blank')
        end
      end

      context 'with priority date blank and considered in the past' do
        it 'raises an error' do
          expect(page).to have_content('minimum')
        end
      end
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
