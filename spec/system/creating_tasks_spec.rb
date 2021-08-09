require 'rails_helper'

RSpec.describe 'CreatingTasks', type: :system do
  before do
    driven_by(:rack_test)
    category
    visit category_path(category)
  end

  let(:category) { Category.create(title: 'Category Title', description: 'Category Description') }

  describe Task do
    subject { described_class.find_by(description: 'Task Description') }
    let(:subject_count) { Task.count }

    context 'when a category was created it redirects to itself and a task can be created' do
      it 'expects form inside' do
        expect(page).to have_current_path(category_path(category))
      end
    end

    context 'when all form fields were filled up and submitted' do
      let(:subject_description) { subject.description }
      let(:subject_priority) { subject.priority }

      before do
        fill_in 'Description', with: 'Task Description'
      end

      context 'with priority date was date today' do
        let(:date_today) { Date.today }

        before do
          fill_in 'task[priority]', with: date_today
          click_on 'Create Task'
        end

        it 'creates a task' do
          expect(subject_description).to eq('Task Description')
          expect(subject_priority).to eq(date_today)
          expect(subject_count).to eq 1
        end

        it 'redirects to same page' do
          expect(page).to have_current_path(category_path(category))
        end

        context 'when navigating under "Tasks for Today"' do
          it 'shows created task' do
            within('#today-wrap') { expect(page).to have_content('Task Description') }
          end
        end
      end

      context 'with priority date was date tomorrow' do
        let(:date_tomorrow) { Date.tomorrow }

        before do
          fill_in 'task[priority]', with: date_tomorrow
          click_on 'Create Task'
        end

        it 'creates a task' do
          expect(subject_description).to eq('Task Description')
          expect(subject_priority).to eq(date_tomorrow)
          expect(subject_count).to eq 1
        end

        it 'redirects to same page' do
          expect(page).to have_current_path(category_path(category))
        end

        context 'when navigating under "Future Tasks"' do
          it 'shows created task' do
            within('#future-wrap') { expect(page).to have_content('Task Description') }
          end
        end
      end
    end

    context 'when all form fields were not filled up and submitted' do
      before do
        click_on 'Create Task'
      end

      it 'does not create a task' do
        expect(subject).to eq nil
        expect(subject_count).to eq 0
      end

      it 'redirects to same page' do
        expect(page).to have_current_path(category_path(category))
      end

      context 'with description blank' do
        it 'renders page without changes' do
          within('#overdue-wrap') { expect(page).to have_content('Nothing else here yet.') }
          within('#today-wrap') { expect(page).to have_content('Nothing else here yet.') }
          within('#future-wrap') { expect(page).to have_content('Nothing else here yet.') }
        end
      end
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
