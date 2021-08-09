require 'rails_helper'

RSpec.describe 'ViewingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:category) { Category.create(title: 'Category Title', description: 'Category Description') }

  let(:task_yesterday) do
    Task.new(description: 'Task Description', priority: Date.yesterday,
             category_id: category.id).save(validate: false)
  end

  let(:task_today) { Task.create(description: 'Task Description', priority: Date.today, category_id: category.id) }

  let(:task_tomorrow) do
    Task.create(description: 'Task Description', priority: Date.tomorrow, category_id: category.id)
  end

  context 'when navigating in page of all categories' do
    before do
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
      before do
        category
        task_today
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
    before do
      category
      visit categories_path
    end

    context 'when there are no tasks yet' do
      before do
        click_on 'Category Title'
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

    context 'when a task for today was created' do
      before do
        task_today
        click_on 'Category Title'
      end

      it 'redirects to its category' do
        expect(page).to have_current_path(category_path(category))
      end

      context 'when navigating under "Tasks for Today"' do
        it 'shows created task' do
          within('#today-wrap') { expect(page).to have_content('Task Description') }
        end
      end
    end

    context 'when a future task was created' do
      before do
        task_tomorrow
        click_on 'Category Title'
      end

      it 'redirects to its category' do
        expect(page).to have_current_path(category_path(category))
      end

      context 'when navigating under "Future Tasks"' do
        it 'shows created task' do
          within('#future-wrap') { expect(page).to have_content('Task Description') }
        end
      end
    end

    context 'when a task was overdue' do
      before do
        task_yesterday
        click_on 'Category Title'
      end

      it 'redirects to its category' do
        expect(page).to have_current_path(category_path(category))
      end

      context 'when navigating under "Overdue Tasks"' do
        it 'shows created task' do
          within('#overdue-wrap') { expect(page).to have_content('Task Description') }
        end
      end
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
