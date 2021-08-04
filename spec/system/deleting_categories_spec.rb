require 'rails_helper'

RSpec.describe "DeletingCategories", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:id) { Category.find_by(title: 'Category Title').id }
  let(:category_count) { Category.count }
  let(:category) { Category.find_by(title: 'Category Title') }

  it "redirects to the 'new' page" do
    visit root_path
    click_on 'New Category'
    expect(page).to have_current_path(new_category_path)
  end

  it 'redirects to the created category' do
    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'
    expect(page).to have_current_path(category_path(id))
  end

  it 'page shows category title' do
    expect(page).to have_content('Category Title')
  end

  it 'page shows category description' do
    expect(page).to have_content('Category Description')
  end

  it 'decreases category count by 1' do
    click_link 'Delete'
    expect(category_count).to eq 0
  end

  it 'category is deleted' do
    expect(category).to eq nil
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
