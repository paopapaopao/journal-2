require 'rails_helper'

RSpec.describe 'DeletingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:click_destroy_task) { find("a[href='/categories/#{category_id}/tasks/#{task_id}']").click }

  let(:category_id) { Category.find_by(title: 'Category Title').id }

  let(:task_id) { Task.find_by(details: 'Task Details').id }
  let(:task_count) { Task.count }

  let(:task) { Task.find_by(details: 'Task Details') }

  it 'deletes a task' do
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'

    fill_in 'Description', with: 'Task Description'
    click_on 'Create Task'

    click_destroy_task
    expect(task_count).to eq 0
    expect(task).to eq nil
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
