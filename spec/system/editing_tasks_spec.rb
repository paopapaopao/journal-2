require 'rails_helper'

RSpec.describe 'EditingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:date_today) { Date.today }
  let(:date_tomorrow) { date_today + 1 }

  let(:category_create) { Category.create(title: 'Category Title', description: 'Category Description') }
  let(:category_id) { Category.find_by(title: 'Category Title').id }

  let(:task_create) { Task.create(description: 'Task Description', priority: date_today, category_id: category_id) }
  let(:task) { Task.find_by(description: 'Task Description') }
  let(:task_id) { task.id }
  let(:task_description) { task.description }
  let(:task_priority) { task.priority }

  let(:task_edited) { Task.find_by(description: 'Task Description Edited') }
  let(:task_edited_description) { Task.find_by(description: 'Task Description Edited').description }
  let(:task_edited_priority) { task_edited.priority }

  let(:click_edit_task) { find("a[href='/categories/#{category_id}/tasks/#{task_id}/edit']").click }

  before :each do
    category_create
    task_create

    visit category_path(category_id)
    click_edit_task
  end

  context 'when task was created within its category, with priority date was date today then it can be edited' do
    it 'goes to form' do
      expect(page).to have_current_path(edit_category_task_path(category_id, task_id))
    end
  end

  context 'when all form fields were filled up with new inputs and submitted with priority date was date tomorrow' do
    before :each do
      fill_in 'Description', with: 'Task Description Edited'
      fill_in 'task[priority]', with: date_tomorrow
      click_on 'Update Task'
    end

    it 'updates task' do
      expect(task_edited_description).to eq('Task Description Edited')
      expect(task_edited_priority).to eq(date_tomorrow)
    end

    it 'redirects to its category' do
      expect(page).to have_current_path(category_path(category_id))
    end

    context 'when navigating under "Future Tasks"' do
      it 'shows updated task' do
        within('#future-wrap') { expect(page).to have_content('Task Description Edited') }
      end
    end
  end

  context 'when all form fields were filled up with blank inputs and submitted' do
    before :each do
      fill_in 'Description', with: ''
      fill_in 'task[priority]', with: ''
      click_on 'Update Task'
    end

    it 'does not edit the task' do
      expect(task_description).to eq('Task Description')
      expect(task_priority).to eq(date_today)
    end

    it 'redirects back to form' do
      expect(page).to have_current_path(category_task_path(category_id, task_id))
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

  # pending "add some scenarios (or delete) #{__FILE__}"
end
