require 'rails_helper'

RSpec.describe "EditingCategories", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:id) { Category.find_by(title: 'Category Title').id }
  let(:category_count) { Category.count }
  let(:category) { Category.find_by(title: 'Category Title Edited') }

  it 'edits a category' do
    visit root_path
    click_on 'New Category'

    expect(page).to have_current_path(new_category_path)
    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'

    expect(page).to have_current_path(category_path(id))
    expect(page).to have_content('Category Title')
    expect(page).to have_content('Category Description')
    click_link 'Edit'

    expect(page).to have_current_path(edit_category_path(id))
    fill_in 'Title', with: 'Category Title Edited'
    fill_in 'Description', with: 'Category Description Edited'
    click_on 'Update Category'

    expect(page).to have_current_path(category_path(id))
    expect(page).to have_content('Category Title Edited')
    expect(page).to have_content('Category Description Edited')

    expect(category_count).to eq 1
    expect(category.title).to eq('Category Title Edited')
    expect(category.description).to eq('Category Description Edited')
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
