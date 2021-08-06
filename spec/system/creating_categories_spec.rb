require 'rails_helper'

RSpec.describe "CreatingCategories", type: :system do
  let(:existing_category) do
    Category.create(
      title: 'not a unique title',
      description: 'description'
    )
  end
  let(:category) { Category.find_by(title: 'Category Title') }
  let(:category_count) { Category.count }

  before :each do
    driven_by(:rack_test)
    visit new_category_path
  end

  context "When visiting the 'new' category page" do
    it { expect(page).to have_current_path(new_category_path) }
    it { expect(page).to have_content('New Category') }
  end

  context 'With invalid field values' do
    context 'When title is not present' do
      it do
        fill_in 'Title', with: ''
        click_on 'Create Category'
        expect(page).to have_content("Title can't be blank")
      end
    end

    context 'When title is not unique' do
      it do
        existing_category
        fill_in 'Title', with: 'not a unique title'
        click_on 'Create Category'
        expect(page).to have_content('Title has already been taken')
      end
    end

    context 'When description is not present' do
      it do
        fill_in 'Description', with: ''
        click_on 'Create Category'
        expect(page).to have_content("Description can't be blank")
      end
    end

    context 'When description is shorter than minimum' do
      it do
        fill_in 'Description', with: 'a' * 9
        click_on 'Create Category'
        expect(page).to have_content('Description is too short (minimum is 10 characters)')
      end
    end

    context 'When description is longer than maximum' do
      it do
        fill_in 'Description', with: 'a' * 101
        click_on 'Create Category'
        expect(page).to have_content('Description is too long (maximum is 100 characters)')
      end
    end
  end

  context 'With valid field values' do
    before :each do
      fill_in 'Title', with: 'Category Title'
      fill_in 'Description', with: 'Category Description'
      click_on 'Create Category'
    end

    it 'redirects to the created category' do
      expect(page).to have_current_path(category_path(category))
    end

    it 'shows title' do
      expect(page).to have_content('Category Title')
    end

    it 'shows description' do
      expect(page).to have_content('Category Description')
    end

    it "title must equal 'Category Title'" do
      expect(category.title).to eq('Category Title')
    end

    it "description must equal 'Category Description'" do
      expect(category.description).to eq('Category Description')
    end

    it 'increases count by 1' do
      expect(category_count).to eq 1
    end
  end
end
