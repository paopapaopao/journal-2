require 'rails_helper'

RSpec.describe "CreatingCategories", type: :system do
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
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'

    expect(page).to have_current_path(category_path(id))
  end

  it 'page shows category title' do
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'

    expect(page).to have_content('Category Title')
  end

  it 'page shows category description' do
    expect(page).to have_content('Category Description')
  end

  it 'increases category count by 1' do
    expect(category_count).to eq 1
  end

  it "category.title == 'Category Title'" do
    expect(category.title).to eq('Category Title')
  end

  it "category.description == 'Category Description'" do
    expect(category.description).to eq('Category Description')
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
