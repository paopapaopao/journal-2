require 'rails_helper'

RSpec.describe 'EditingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:category_id) { Category.find_by(title: 'Category Title').id }
  let(:task) { Task.find_by(description: 'Task Description') }
  let(:task_id) { task.id }
  let(:click_edit_task) { find("a[href='/categories/#{category_id}/tasks/#{task_id}/edit']").click }

  before :each do
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'

    fill_in 'Description', with: 'Task Description'
    click_on 'Create Task'

    click_edit_task

    expect(page).to have_current_path(edit_category_task_path(category_id, task_id))
  end

  let(:task_count) { Task.count }
  let(:task_edited) { Task.find_by(description: 'Task Description Edited') }
  let(:task_edited_description) { Task.find_by(description: 'Task Description Edited').description }
  let(:task_description) { task.description }

  context 'when valid' do
    it 'edits a task' do
      fill_in 'Description', with: 'Task Description Edited'
      click_on 'Update Task'

      expect(page).to have_current_path(category_path(category_id))
      expect(page).to have_content('Task Description Edited')

      expect(task_count).to eq 1
      expect(task_edited_description).to eq('Task Description Edited')
    end
  end

  context 'when invalid' do
    before :each do
      fill_in 'Description', with: ''
      click_on 'Update Task'

      expect(page).to have_current_path(category_task_path(category_id, task_id))
    end

    it 'raises an error' do
      expect(page).to have_content('blank')
      expect(page).to have_content('minimum')
    end

    it 'does not edit a task' do
      expect(task_count).to eq 1
      expect(task_description).to eq('Task Description')
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
