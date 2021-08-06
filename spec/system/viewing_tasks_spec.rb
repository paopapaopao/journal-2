require 'rails_helper'

RSpec.describe 'ViewingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:date_today) { Date.today }
  let(:category_id) { Category.find_by(title: 'Category Title').id }

  before :each do
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'

    fill_in 'Description', with: 'Task Description'
    click_on 'Create Task'

    visit root_path
    click_link 'Category Title'
  end

  it 'redirects to its category' do
    expect(page).to have_current_path(category_path(category_id))
  end

  it 'renders page with its contents' do
    expect(page).to have_content('Task Description')
    expect(page).to have_content(date_today)
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
