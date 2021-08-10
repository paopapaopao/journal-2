require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new }

  let :existing_user do
    described_class.create(
      email: 'not.unique@example.com',
      encrypted_password: 'password'
    )
  end

  let(:user_on_categories) { User.reflect_on_association(:categories).macro }

  context 'with associations' do
    it 'has many categories' do
      expect(User.reflect_on_association(:categories).macro).to eq :has_many
    end

    it 'has many tasks' do
      expect(User.reflect_on_association(:tasks).macro).to eq :has_many
    end
  end

  context 'with dependents' do
    let(:category) do
      Category.create(title: 'Category Title',
                      description: 'Category Description',
                      user_id: existing_user.id)
    end

    let(:task) do
      Task.create(description: 'Task Description',
                  priority: Date.today,
                  user_id: existing_user.id,
                  category_id: category.id)
    end

    it 'deletes its categories' do
      category
      existing_user.destroy
      expect(Category.find_by(user_id: existing_user.id)).to eq nil
    end

    it 'deletes its tasks' do
      category
      task
      existing_user.destroy
      expect(Task.find_by(user_id: existing_user.id)).to eq nil
    end
  end

  context 'When email address is not present' do
    context 'It is nil' do
      it do
        subject.email = nil
        expect(subject).to_not be_valid
      end
    end

    context 'It is an empty string' do
      it do
        subject.email = ''
        expect(subject).to_not be_valid
      end
    end
  end

  context 'When email address is not unique' do
    it do
      existing_user
      subject.email = 'not.unique@example.com'
      expect(subject).to_not be_valid
    end
  end

  context 'When email address is unique' do
    it do
      subject.email = 'unique@example.com'
      expect(subject).to_not be_valid
    end
  end

  context 'When password is not present' do
    context 'It is nil' do
      it do
        subject.encrypted_password = nil
        expect(subject).to_not be_valid
      end
    end

    context 'It is an empty string' do
      it do
        subject.encrypted_password = ''
        expect(subject).to_not be_valid
      end
    end
  end
end
