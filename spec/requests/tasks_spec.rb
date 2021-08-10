require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let(:user) do
    User.create(email: 'example@mail.com',
                password: 'password')
  end

  let(:category) do
    Category.create(title: 'Category Title',
                    description: 'Category Description',
                    user_id: user.id)
  end

  describe Task do
    let(:valid_attributes) do
      {
        description: 'Task Description',
        priority: Date.today,
        user_id: user.id,
        category_id: category.id
      }
    end

    let(:invalid_attributes) do
      {
        description: nil,
        priority: nil,
        user_id: nil,
        category_id: nil
      }
    end

    subject { described_class.create(valid_attributes) }
    let(:subject_count) { Task.count }

    context 'when user signed in' do
      before do
        sign_in user
        category
      end

      describe 'GET /index' do
        it 'raises error' do
          expect do
            get category_tasks_url(category)
          end.to raise_error(ActionController::RoutingError)
        end

        # pending "add some examples (or delete) #{__FILE__}"
      end

      describe 'GET /show' do
        it 'raises error' do
          expect do
            get category_task_url(category, subject)
          end.to raise_error(ActionController::RoutingError)
        end
      end

      describe 'GET /new' do
        it 'raises error' do
          expect do
            get "/categories/#{category.id}/tasks/new"
          end.to raise_error(ActionController::RoutingError)
        end
      end

      describe 'GET /edit' do
        it 'responds sucessfully' do
          get edit_category_task_url(category, subject)
          expect(response).to be_successful
        end
      end

      describe 'POST /create' do
        context 'when valid' do
          before do
            post category_tasks_url(category), params: { task: valid_attributes }
          end

          it 'creates a task' do
            expect(subject_count).to eq 1
          end

          it 'redirects to its category' do
            expect(response).to redirect_to(category_url(category))
          end
        end

        context 'when invalid' do
          before do
            post category_tasks_url(category), params: { task: invalid_attributes }
          end

          it 'does not create a task' do
            expect(subject_count).to eq 0
          end

          it 'redirects to its category' do
            expect(response).to redirect_to(category_url(category))
          end
        end
      end

      describe 'PATCH /update' do
        let(:new_attributes) do
          {
            description: 'Task Description Edited',
            priority: Date.tomorrow
          }
        end

        let(:subject_updated) { Task.find_by(new_attributes) }

        context 'when valid' do
          before do
            patch category_task_url(category, subject), params: { task: new_attributes }
          end

          it 'updates task' do
            expect(subject_updated).to_not eq nil
          end

          it 'redirects to itself' do
            expect(response).to redirect_to(category_url(category))
          end
        end

        context 'when invalid' do
          before do
            patch category_task_url(category, subject), params: { task: invalid_attributes }
          end

          it 'does not update task' do
            expect(subject_updated).to eq nil
          end

          it 'responds successfully' do
            expect(response).to be_successful
          end
        end
      end

      describe 'DELETE /destroy' do
        before do
          delete category_task_url(category, subject)
        end

        it 'deletes the task' do
          expect(subject_count).to eq 0
        end

        it 'redirects to all categories' do
          expect(response).to redirect_to(category_url(category))
        end
      end
    end

    context 'when user not signed in' do
      before do
        category
      end

      describe 'GET /index' do
        it 'raises error' do
          expect do
            get category_tasks_url(category)
          end.to raise_error(ActionController::RoutingError)
        end
      end

      describe 'GET /show' do
        it 'raises error' do
          expect do
            get category_task_url(category, subject)
          end.to raise_error(ActionController::RoutingError)
        end
      end

      describe 'GET /new' do
        it 'raises error' do
          expect do
            get "/categories/#{category.id}/tasks/new"
          end.to raise_error(ActionController::RoutingError)
        end
      end

      describe 'GET /edit' do
        before do
          get edit_category_task_url(category, subject)
        end

        it 'redirects to log in' do
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end
end
