require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  let(:user) do
    User.create(email: 'example@mail.com',
                password: 'password')
  end

  before do
    user
  end

  describe Category do
    let(:valid_attributes) do
      {
        title: 'Category Title',
        description: 'Category Description',
        user_id: user.id
      }
    end

    let(:invalid_attributes) do
      {
        title: nil,
        description: nil,
        user_id: nil
      }
    end

    subject { described_class.create(valid_attributes) }
    let(:subject_count) { Category.count }

    describe 'GET /index' do
      before do
        get categories_path
      end

      it 'responds successfully' do
        expect(response).to be_successful
      end

      # pending "add some examples (or delete) #{__FILE__}"
    end

    describe 'GET /show' do
      before do
        get category_path(subject)
      end

      it 'responds successfully' do
        expect(response).to be_successful
      end
    end

    describe 'GET /new' do
      before do
        get new_category_path
      end

      it 'responds successfully' do
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      before do
        get edit_category_path(subject)
      end

      it 'responds successfully' do
        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      context 'when valid' do
        before do
          subject
          post categories_path, params: { category: valid_attributes }
        end

        it 'creates a category' do
          expect(subject_count).to eq 1
        end

        it 'responds successfully' do
          expect(response).to be_successful
        end
      end

      context 'when invalid' do
        before do
          post categories_path, params: { category: invalid_attributes }
        end

        it 'does not create a category' do
          expect(subject_count).to eq 0
        end

        it 'responds successfully' do
          expect(response).to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      let(:new_attributes) do
        {
          title: 'Category Title Edited',
          description: 'Category Description Edited'
        }
      end

      let(:subject_updated) { Category.find_by(new_attributes) }

      context 'when valid' do
        before do
          patch category_path(subject), params: { category: new_attributes }
        end

        it 'updates category' do
          expect(subject_updated).to_not eq nil
        end

        it 'redirects to itself' do
          expect(response).to redirect_to(category_path(subject))
        end
      end

      context 'when invalid' do
        before do
          patch category_path(subject), params: { category: invalid_attributes }
        end

        it 'does not update category' do
          expect(subject_updated).to eq nil
        end

        it 'responds successfully' do
          expect(response).to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      before do
        delete category_path(subject)
      end

      it 'deletes the category' do
        expect(subject_count).to eq 0
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
