require 'rails_helper'

RSpec.describe 'ViewingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) do
    User.create(email: 'example@mail.com',
                password: 'password')
  end

  let(:category) do
    Category.create(title: 'Category Title',
                    description: 'Category Description',
                    user_id: user.id)
  end

  let(:click_show_category) { find("a[href='/categories/#{category.id}']").click }

  let(:task_today) do
    Task.create(description: 'Task Description',
                priority: Date.today,
                user_id: user.id,
                category_id: category.id)
  end

  context 'when user logged in' do
    before do
      sign_in user
    end

    context 'when navigating in page of all categories' do
      it 'shows heading' do
        visit categories_path
        within('#today-wrap') { expect(page).to have_content('Tasks for Today') }
      end

      context 'when there are no tasks for today yet' do
        before do
          visit categories_path
        end

        it 'shows "nothing" message' do
          within('#today-wrap') { expect(page).to have_content('No tasks for today.') }
        end
      end

      context 'when a task for today was created' do
        before do
          category
          task_today
          visit categories_path
        end

        it 'shows created task' do
          within('#today-wrap') { expect(page).to have_content(task_today.description) }
        end
      end
    end

    context 'when navigating through tasks inside a category' do
      before do
        category
        visit categories_path
      end

      context 'when navigating under "Overdue Tasks"' do
        let(:task_yesterday) do
          Task.new(description: 'Task Description',
                   priority: Date.yesterday,
                   user_id: user.id,
                   category_id: category.id)
        end

        context 'when there are no tasks' do
          before do
            click_show_category
          end

          it 'shows heading' do
            within('#overdue-wrap') { expect(page).to have_content('Overdue Tasks') }
          end

          it 'shows "nothing" message' do
            within('#overdue-wrap') { expect(page).to have_content('Nothing else here yet.') }
          end
        end

        context 'when a task was overdue' do
          before do
            task_yesterday.save(validate: false)
            click_show_category
          end

          it 'shows task' do
            within('#overdue-wrap') { expect(page).to have_content(task_yesterday.description) }
          end
        end
      end

      context 'when navigating under "Tasks for Today"' do
        context 'when there are no tasks' do
          before do
            click_show_category
          end

          it 'shows heading' do
            within('#today-wrap') { expect(page).to have_content('Tasks for Today') }
          end

          it 'shows "nothing" message' do
            within('#today-wrap') { expect(page).to have_content('Nothing else here yet.') }
          end
        end

        context 'when a task was created' do
          before do
            task_today
            click_show_category
          end

          it 'shows task' do
            within('#today-wrap') { expect(page).to have_content(task_today.description) }
          end
        end
      end

      context 'when navigating under "Future Tasks"' do
        let(:task_tomorrow) do
          Task.create(description: 'Task Description',
                      priority: Date.tomorrow,
                      user_id: user.id,
                      category_id: category.id)
        end

        context 'when there are no tasks' do
          before do
            click_show_category
          end

          it 'shows heading' do
            within('#future-wrap') { expect(page).to have_content('Future Tasks') }
          end

          it 'shows "nothing" message' do
            within('#future-wrap') { expect(page).to have_content('Nothing else here yet.') }
          end
        end

        context 'when a task was created' do
          before do
            task_tomorrow
            click_show_category
          end

          it 'shows task' do
            within('#future-wrap') { expect(page).to have_content(task_tomorrow.description) }
          end
        end
      end
    end
  end

  context 'when user not logged in' do
    context 'when navigating in page of all categories' do
      before do
        visit categories_path
      end

      it 'shows "please login" message' do
        expect(page).to have_content('Please log in')
      end
    end

    context 'when navigating through tasks inside a category' do
      before do
        visit category_path(category)
      end

      it 'shows "sign in" message' do
        expect(page).to have_content('need to sign in')
      end
    end
  end
end
