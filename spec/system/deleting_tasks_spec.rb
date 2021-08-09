require 'rails_helper'

RSpec.describe 'DeletingTasks', type: :system do
  before do
    driven_by(:rack_test)
    category
  end

  let(:category) { Category.create(title: 'Category Title', description: 'Category Description') }

  describe Task do
    let(:attributes) do
      {
        description: 'Task Description',
        priority: Date.today,
        category_id: category.id
      }
    end

    subject { described_class.create(attributes) }
    let(:click_destroy) { find("a[href='/categories/#{category.id}/tasks/#{subject.id}']").click }

    before do
      subject
      visit category_path(category)
    end

    context 'when task was created within its category' do
      it 'redirects to same page' do
        expect(page).to have_current_path(category_path(category))
      end
    end

    context 'with that task can be deleted' do
      before do
        click_destroy
      end

      it 'deletes the task' do
        expect(Task.find_by(attributes)).to eq nil
        expect(Task.count).to eq 0
      end
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
