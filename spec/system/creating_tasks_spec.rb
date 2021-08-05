require 'rails_helper'

RSpec.describe 'CreatingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:category_id) { Category.find_by(title: 'Category Title').id }

  before :each do
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'
  end

  let(:task_count) { Task.count }
  let(:task) { Task.find_by(description: 'Task Description') }
  let(:task_description) { task.description }

  context 'when valid' do
    it 'creates a task' do
      fill_in 'Description', with: 'Task Description'
      click_on 'Create Task'

      expect(page).to have_current_path(category_path(category_id))
      expect(page).to have_content('Task Description')

      expect(task_count).to eq 1
      expect(task_description).to eq('Task Description')
    end
  end

  context 'when invalid' do
    it 'does not create a task' do
      click_on 'Create Task'

      expect(page).to have_current_path(category_path(category_id))

      expect(task_count).to eq 0
      expect(task).to eq nil
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
