require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  let(:valid_attributes) do
    {
      title: 'Category Title',
      description: 'Category Description'
    }
  end
  let(:invalid_attributes) do
    {
      title: nil,
      description: nil
    }
  end
  let(:new_attributes) do
    {
      title: 'Category Title Edited',
      description: 'Category Description Edited'
    }
  end

  subject do
    Category.new(valid_attributes)
  end

  let(:subject_save) { subject.save }
  let(:category_count) { Category.count }

  describe 'GET /index' do
    it 'finishes method successfully' do
      get categories_path
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    context 'When subject is not saved' do
      it 'finishes method unsuccessfully' do
        get category_path(subject)
        expect(response).to_not be_successful
      end
    end

    context 'When subject is saved' do
      it 'finishes method successfully' do
        subject_save
        get category_path(subject)
        expect(response).to be_successful
      end
    end
  end

  describe 'GET /new' do
    it 'finishes method successfully' do
      get new_category_path
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    context 'When subject is not saved' do
      it 'finishes method unsuccessfully' do
        get edit_category_path(subject)
        expect(response).to_not be_successful
      end
    end

    context 'When subject is saved' do
      it 'finishes method successfully' do
        category_save
        get edit_category_path(subject)
        expect(response).to be_successful
      end
    end
  end

  describe 'POST /create' do
    context 'With invalid parameters' do
      it 'finishes method unsuccessfully' do
        category_save
        post categories_path, params: { category: invalid_attributes }
        expect(category_count).to eq 0
        expect(response).to_not be_successful
      end
    end

    context 'With valid parameters' do
      it 'finishes method successfully' do
        category_save
        post categories_path, params: { category: valid_attributes }
        expect(category_count).to eq 1
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'With invalid parameters' do
      it 'finishes method unsuccessfully' do
        category_save
        patch category_path(subject), params: { category: invalid_attributes }
        expect(category_count).to eq 1
        expect(response).to_not be_successful
      end
    end

    context 'With valid parameters' do
      it 'finishes method successfully' do
        category_save
        patch category_path(subject), params: { category: new_attributes }
        expect(category_count).to eq 1
        expect(response).to redirect_to(:category)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'finishes method successfully' do
      category_save
      delete category_path(subject)
      expect(category_count).to eq 0
      expect(response).to redirect_to(root_path)
    end
  end
end
