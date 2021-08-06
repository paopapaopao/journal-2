require 'rails_helper'

RSpec.describe "ViewingCategories", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:id) { Category.find_by(title: 'Category Title').id }

  before :each do
    visit root_path
    click_on 'New Category'

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

  it "goes to 'edit' page" do
    click_link 'Edit'
    expect(page).to have_current_path(edit_category_path(id))
  end

  it "goes to 'index' page" do
    click_link 'Back'
    expect(page).to have_current_path(categories_path)
  end
end
