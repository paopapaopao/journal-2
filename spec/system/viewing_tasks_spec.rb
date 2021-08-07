require 'rails_helper'

RSpec.describe 'ViewingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:date_today) { Date.today }

  let(:category_create) { Category.create(title: 'Category Title', description: 'Category Description') }
  let(:category_id) { Category.find_by(title: 'Category Title').id }

  let(:task_create) { Task.create(description: 'Task Description', priority: date_today, category_id: category_id) }

  context 'when navigating in page of all categories' do
    before :each do
      visit categories_path
    end

    context 'when there are no tasks for today yet' do
      it 'shows heading' do
        within('#today-wrap') { expect(page).to have_content('Tasks for Today') }
      end

      it 'shows "nothing" message' do
        within('#today-wrap') { expect(page).to have_content('No tasks for today.') }
      end
    end

    context 'when a task for today was created' do
      before :each do
        category_create
        task_create
      end

      it 'shows heading' do
        within('#today-wrap') { expect(page).to have_content('Tasks for Today') }
      end

      it 'shows "nothing" message' do
        within('#today-wrap') { expect(page).to have_content('No tasks for today.') }
      end
    end
  end

  context 'when navigating through tasks inside a category' do
    before :each do
      category_create
      visit categories_path
    end

    context 'when there are no tasks yet' do
      before :each do
        click_link 'Category Title'
      end

      context 'when navigating under "Overdue Tasks"' do
        it 'shows heading' do
          within('#overdue-wrap') { expect(page).to have_content('Overdue Tasks') }
        end

        it 'shows "nothing" message' do
          within('#overdue-wrap') { expect(page).to have_content('Nothing else here yet.') }
        end
      end

      context 'when navigating under "Tasks for Today"' do
        it 'shows heading' do
          within('#today-wrap') { expect(page).to have_content('Tasks for Today') }
        end

        it 'shows "nothing" message' do
          within('#today-wrap') { expect(page).to have_content('Nothing else here yet.') }
        end
      end

      context 'when navigating under "Future Tasks"' do
        it 'shows heading' do
          within('#future-wrap') { expect(page).to have_content('Future Tasks') }
        end

        it 'shows "nothing" message' do
          within('#future-wrap') { expect(page).to have_content('Nothing else here yet.') }
        end
      end
    end

    context 'when a task was created' do
      before :each do
        task_create
        click_link 'Category Title'
      end

      it 'redirects to its category' do
        expect(page).to have_current_path(category_path(category_id))
      end

      context 'when navigating under "Tasks for Today"' do
        it 'shows created task' do
          within('#today-wrap') { expect(page).to have_content('Task Description') }
        end
      end
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
