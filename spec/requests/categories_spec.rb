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
    it 'finishes method successfully' do
      subject_save
      get category_path(subject)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'finishes method successfully' do
      get new_category_path
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'finishes method successfully' do
      subject_save
      get edit_category_path(subject)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'With invalid parameters' do
      it "category count remains the same" do
        expect {
          post categories_path, params: { category: invalid_attributes }
        }.to change(Category, :count).by(0)
      end

      it "remains in the 'new' page)" do
        post categories_path, params: { category: invalid_attributes }
        expect(response).to_not be_successful
      end
    end

    context 'With valid parameters' do
      it "increases category count by 1" do
        expect {
          post categories_path, params: { category: valid_attributes }
        }.to change(Category, :count).by(1)
      end

      it "redirects to the created category" do
        post categories_path, params: { category: valid_attributes }
        expect(response).to redirect_to(category_path(Category.last))
      end
    end
  end

  describe 'PATCH /update' do
    context 'With invalid parameters' do
      it "remains in the 'edit' page)" do
        subject_save
        patch category_path(subject), params: { category: invalid_attributes }
        expect(response).to_not be_successful
      end
    end

    context 'With valid parameters' do
      it "redirects to the updated category" do
        subject_save
        patch category_path(subject), params: { category: new_attributes }
        subject.reload
        expect(response).to redirect_to(category_path(subject))
      end
    end
  end

  describe 'DELETE /destroy' do
    it "decreases category count by 1" do
      subject_save
      expect {
        delete category_path(subject)
      }.to change(Category, :count).by(-1)
    end

    it "redirects to the 'index' page" do
      subject_save
      delete category_path(subject)
      expect(response).to redirect_to(categories_path)
    end
  end
end
