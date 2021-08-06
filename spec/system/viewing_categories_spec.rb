require 'rails_helper'

RSpec.describe "ViewingCategories", type: :system do
  let(:category) do
    Category.create(
      title: 'Category Title',
      description: 'Category Description'
    )
  end

  before :each do
    driven_by(:rack_test)
    visit category_path(category)
  end

  it 'goes to the created category' do
    expect(page).to have_current_path(category_path(category))
  end

  it 'shows title' do
    expect(page).to have_content('Category Title')
  end

  it 'shows description' do
    expect(page).to have_content('Category Description')
  end

  it "goes to 'edit' page" do
    click_link 'Edit'
    expect(page).to have_current_path(edit_category_path(category))
  end

  it "returns to 'index' page" do
    click_link 'Back'
    expect(page).to have_current_path(categories_path)
  end
end
