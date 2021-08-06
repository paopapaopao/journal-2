require 'rails_helper'

RSpec.describe "DeletingCategories", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:id) { Category.find_by(title: 'Category Title').id }
  let(:category_count) { Category.count }
  let(:category) { Category.find_by(title: 'Category Title') }

  before :each do
    visit new_category_path
    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'
    visit root_path
  end

  it "goes to the 'index' page" do
    expect(page).to have_current_path('/')
  end

  it 'shows title' do
    expect(page).to have_content('Category Title')
  end

  it 'shows description' do
    expect(page).to have_content('Category Description')
  end

  it 'decreases category count by 1' do
    click_link 'Destroy'
    expect(category_count).to eq 0
  end

  it 'category is deleted' do
    click_link 'Destroy'
    expect(category).to eq nil
  end
end
