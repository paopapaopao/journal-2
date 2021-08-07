require 'rails_helper'

RSpec.describe 'DeletingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:date_today) { Date.today }

  let(:category_create) { Category.create(title: 'Category Title', description: 'Category Description') }
  let(:category_id) { Category.find_by(title: 'Category Title').id }

  let(:task_create) { Task.create(description: 'Task Description', priority: date_today, category_id: category_id) }
  let(:task_id) { Task.find_by(description: 'Task Description').id }
  let(:task_count) { Task.count }
  let(:task_deleted) { Task.find_by(description: 'Task Description') }

  let(:click_destroy_task) { find("a[href='/categories/#{category_id}/tasks/#{task_id}']").click }

  before :each do
    category_create
    task_create

    visit category_path(category_id)
  end

  context 'when task was created within its category' do
    it 'redirects to same page' do
      expect(page).to have_current_path(category_path(category_id))
    end
  end

  context 'with that task can be deleted' do
    before do
      click_destroy_task
    end

    it 'deletes the task' do
      expect(task_deleted).to eq nil
      expect(task_count).to eq 0
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
