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
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'

    expect(page).to have_content('Category Description')
  end

  it "redirect to the 'edit' page" do
    click_link 'Edit'
    expect(page).to have_current_path(edit_category_path(id))
  end

  it 'redirect to the updated category' do
    fill_in 'Title', with: 'Category Title Edited'
    fill_in 'Description', with: 'Category Description Edited'
    click_on 'Update Category'
    expect(page).to have_current_path(category_path(id))
  end

  it 'page shows updated title' do
    expect(page).to have_content('Category Title Edited')
  end

  it 'page shows updated description' do
    expect(page).to have_content('Category Description Edited')
  end

  it 'category count stays the same' do
    expect(category_count).to eq 1
  end

  it 'category title is updated' do
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'

    expect(category.title).to eq('Category Title Edited')
  end

  it 'category description is updated' do
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'

    visit root_path
    click_link 'Edit'

    visit category_path(subject)

    expect(subject.description).to eq('description')
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
