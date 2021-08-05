require 'rails_helper'

RSpec.describe 'ViewingTasks', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:category_id) { Category.find_by(title: 'Category Title').id }
  let(:click_show_category) { find("a[href='/categories/#{category_id}']").click }

  it 'views a task' do
    visit root_path
    click_on 'New Category'

    fill_in 'Title', with: 'Category Title'
    fill_in 'Description', with: 'Category Description'
    click_on 'Create Category'

    fill_in 'Description', with: 'Task Description'
    click_on 'Create Task'

    visit root_path
    click_link 'Category Title'

    expect(page).to have_current_path(category_path(category_id))
    expect(page).to have_content('Task Description')
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
