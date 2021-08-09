require 'rails_helper'

RSpec.describe 'CreatingTasks', type: :system do
  before do
    driven_by(:rack_test)
    sign_in user
    category
    visit category_path(category)
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

  context 'when a category was created it redirects to itself and a task can be created' do
    it 'expects form inside' do
      expect(page).to have_current_path(category_path(category))
    end

    it 'expects hidden field' do
      expect(find('input[type="hidden"]', visible: false).value).to eq(user.id.to_s)
    end
  end

  describe Task do
    subject { described_class.find_by(description: 'Task Description') }
    let(:subject_count) { Task.count }

    let(:click_create) { find('input[type="submit"]').click }

    context 'when all form fields were filled up and submitted' do
      let(:date_today) { Date.today }

      before do
        fill_in 'Description', with: 'Task Description'
        fill_in 'task[priority]', with: date_today
        click_create
      end

      it 'creates a task' do
        expect(subject).to_not eq nil
        expect(subject_count).to eq 1
      end

      it 'redirects to same page' do
        expect(page).to have_current_path(category_path(category))
      end

      it 'renders page with submitted inputs' do
        expect(page).to have_content(subject.description)
      end
    end

    context 'when all form fields were not filled up and submitted' do
      before do
        click_create
      end

      it 'does not create a task' do
        expect(subject).to eq nil
        expect(subject_count).to eq 0
      end

      it 'redirects to same page' do
        expect(page).to have_current_path(category_path(category))
      end

      it 'renders page without changes' do
        within('#overdue-wrap') { expect(page).to have_content('Nothing else here yet.') }
        within('#today-wrap') { expect(page).to have_content('Nothing else here yet.') }
        within('#future-wrap') { expect(page).to have_content('Nothing else here yet.') }
      end
    end
  end
end
