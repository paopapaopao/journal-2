require 'rails_helper'

RSpec.describe 'EditingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:click_edit_task) { find("a[href='/categories/#{category_id}/tasks/#{task_id}/edit']").click }

  let(:date_today) { Date.today }
  let(:date_tomorrow) { date_today + 1 }

  let(:category_id) { Category.find_by(title: 'Category Title').id }

  let(:task) { Task.find_by(description: 'Task Description') }
  let(:task_id) { task.id }
  let(:task_description) { task.description }
  let(:task_priority) { task.priority }
  let(:task_count) { Task.count }

  let(:task_edited) { Task.find_by(description: 'Task Description Edited') }
  let(:task_edited_description) { Task.find_by(description: 'Task Description Edited').description }
  let(:task_edited_priority) { task_edited.priority }

  before :each do
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'

    fill_in 'Description', with: 'Task Description'
    click_on 'Create Task'

    click_edit_task
  end

  it 'redirects to edit category task path' do
    expect(page).to have_current_path(edit_category_task_path(category_id, task_id))
  end

  context 'when all form fields are filled up with new inputs and submitted' do
    before :each do
      fill_in 'Description', with: 'Task Description Edited'
      fill_in 'task[priority]', with: date_tomorrow
      click_on 'Update Task'
    end

    it 'redirects to its category' do
      expect(page).to have_current_path(category_path(category_id))
    end

    it 'renders page with submitted inputs' do
      expect(page).to have_content('Task Description Edited')
      expect(page).to have_content(date_tomorrow)
    end

    it 'edits the task' do
      expect(task_count).to eq 1
      expect(task_edited_description).to eq('Task Description Edited')
      expect(task_edited_priority).to eq(date_tomorrow)
    end
  end

  context 'when all form fields are filled up with blank inputs and submitted' do
    before :each do
      fill_in 'Description', with: ''
      fill_in 'task[priority]', with: ''
      click_on 'Update Task'
    end

    it 'redirects to same page' do
      expect(page).to have_current_path(category_task_path(category_id, task_id))
    end

    it 'raises errors' do
      expect(page).to have_content('blank')
      expect(page).to have_content('minimum')
    end

    it 'does not edit the task' do
      expect(task_count).to eq 1
      expect(task_description).to eq('Task Description')
      expect(task_priority).to eq(date_today)
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
