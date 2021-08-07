require 'rails_helper'

RSpec.describe 'CreatingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:date_today) { Date.today }
  let(:date_tomorrow) { date_today + 1 }

  let(:category_create) { Category.create(title: 'Category Title', description: 'Category Description') }
  let(:category_id) { Category.find_by(title: 'Category Title').id }

  let(:task) { Task.find_by(description: 'Task Description') }
  let(:task_description) { task.description }
  let(:task_priority) { task.priority }
  let(:task_count) { Task.count }

  before :each do
    category_create
    visit category_path(category_id)
  end

  context 'when a category was created it redirects to itself and a task can be created' do
    it 'expects form inside' do
      expect(page).to have_current_path(category_path(category_id))
    end
  end

  context 'when all form fields were filled up and submitted' do
    before :each do
      fill_in 'Description', with: 'Task Description'
    end

    context 'with priority date was date today' do
      before :each do
        fill_in 'task[priority]', with: date_today
        click_on 'Create Task'
      end

      it 'creates a task' do
        expect(task_description).to eq('Task Description')
        expect(task_priority).to eq(date_today)
        expect(task_count).to eq 1
      end

      it 'redirects to same page' do
        expect(page).to have_current_path(category_path(category_id))
      end

      context 'when navigating under "Tasks for Today"' do
        it 'shows created task' do
          within('#today-wrap') { expect(page).to have_content('Task Description') }
        end
      end
    end

    context 'with priority date was date tomorrow' do
      before :each do
        fill_in 'task[priority]', with: date_tomorrow
        click_on 'Create Task'
      end

      it 'creates a task' do
        expect(task_description).to eq('Task Description')
        expect(task_priority).to eq(date_tomorrow)
        expect(task_count).to eq 1
      end

      it 'redirects to same page' do
        expect(page).to have_current_path(category_path(category_id))
      end

      context 'when navigating under "Future Tasks"' do
        it 'shows created task' do
          within('#future-wrap') { expect(page).to have_content('Task Description') }
        end
      end
    end
  end

  context 'when all form fields were not filled up and submitted' do
    before :each do
      click_on 'Create Task'
    end

    it 'does not create a task' do
      expect(task).to eq nil
      expect(task_count).to eq 0
    end

    it 'redirects to same page' do
      expect(page).to have_current_path(category_path(category_id))
    end

    context 'with description blank' do
      it 'renders page without changes' do
        within('#overdue-wrap') { expect(page).to have_content('Nothing else here yet.') }
        within('#today-wrap') { expect(page).to have_content('Nothing else here yet.') }
        within('#future-wrap') { expect(page).to have_content('Nothing else here yet.') }
      end
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
