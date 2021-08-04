require 'rails_helper'

RSpec.describe "ViewingCategories", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:id) { Category.find_by(title: 'Category Title').id }

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

  it 'redirect to the category' do
    visit root_path
    click_link 'Category Title'
    expect(page).to have_current_path(category_path(id))
  end

  it 'page shows category title' do
    expect(page).to have_content('Category Title')
  end

  it 'page shows category description' do
    expect(page).to have_content('Category Description')
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
