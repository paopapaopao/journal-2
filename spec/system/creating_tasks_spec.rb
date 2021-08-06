require 'rails_helper'

RSpec.describe 'CreatingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:date_today) { Date.today }

  let(:category_id) { Category.find_by(title: 'Category Title').id }

  let(:task) { Task.find_by(description: 'Task Description') }
  let(:task_description) { task.description }
  let(:task_priority) { task.priority }
  let(:task_count) { Task.count }

  before :each do
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'
  end

  context 'when all form fields are filled up and submitted' do
    before :each do
      fill_in 'Description', with: 'Task Description'
      fill_in 'task[priority]', with: date_today
      click_on 'Create Task'
    end

    it 'redirects to same page' do
      expect(page).to have_current_path(category_path(category_id))
    end

    it 'renders page with submitted inputs' do
      expect(page).to have_content('Task Description')
      expect(page).to have_content(date_today)
    end

    it 'creates a task' do
      expect(task_description).to eq('Task Description')
      expect(task_priority).to eq(date_today)
      expect(task_count).to eq 1
    end
  end

  context 'when all form fields are not filled up and submitted' do
    before :each do
      click_on 'Create Task'
    end

    it 'redirects to same page' do
      expect(page).to have_current_path(category_path(category_id))
    end

    it 'does not create a task' do
      expect(page).to have_current_path(category_path(category_id))

      expect(task_count).to eq 0
      expect(task).to eq nil
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
