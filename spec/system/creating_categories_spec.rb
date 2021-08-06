require 'rails_helper'

RSpec.describe "CreatingCategories", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:id) { Category.find_by(title: 'Category Title').id }
  let(:category_count) { Category.count }
  let(:category) { Category.find_by(title: 'Category Title') }

  before :each do
    visit new_category_path
  end

  context "When visiting the 'new' category page" do
    it { expect(page).to have_current_path(new_category_path) }
    it { expect(page).to have_content('New Category') }
  end

  context 'When creating a category' do
    before :each do
      fill_in 'Title', with: 'Category Title'
      fill_in 'Description', with: 'Category Description'
      click_on 'Create Category'
    end

    it 'redirects to the created category' do
      expect(page).to have_current_path(category_path(id))
    end

    it 'shows title' do
      expect(page).to have_content('Category Title')
    end

    it 'shows description' do
      expect(page).to have_content('Category Description')
    end

    it 'increases count by 1' do
      expect(category_count).to eq 1
    end

    it "title must equal 'Category Title'" do
      expect(category.title).to eq('Category Title')
    end

    it "description must equal 'Category Description'" do
      expect(category.description).to eq('Category Description')
    end
  end
end
