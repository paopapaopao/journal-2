require 'rails_helper'

RSpec.describe "EditingCategories", type: :system do
  before do
    driven_by(:rack_test)
  end

  subject do
    Category.create(
      title: 'title',
      description: 'description'
    )
  end

  let(:id) { Category.find_by(title: 'Category Title').id }
  let(:category_count) { Category.count }
  let(:category) { Category.find_by(title: 'Category Title Edited') }

  before :each do
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'

    click_link 'Edit'
  end

  context "When visiting the 'edit' category page" do
    it { expect(page).to have_current_path(edit_category_path(id)) }
    it { expect(page).to have_content('Editing Category') }
  end

  context 'When updating a category' do
    before :each do
      fill_in 'Title', with: 'Category Title Edited'
      fill_in 'Description', with: 'Category Description Edited'
      click_on 'Update Category'
    end

    it 'redirects to the updated category' do
      expect(page).to have_current_path(category_path(category))
    end

    it 'shows title' do
      expect(page).to have_content('Category Title Edited')
    end

    it 'shows description' do
      expect(page).to have_content('Category Description Edited')
    end

    it "title must equal 'Category Title Edited'" do
      expect(category.title).to eq('Category Title Edited')
    end

    it 'category description is updated' do
      expect(category.description).to eq('Category Description Edited')
    end
  end
end
