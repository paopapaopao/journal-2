require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:user) do
    User.create(email: 'example@mail.com',
                password: 'password')
  end

  subject do
    described_class.new(title: 'Category Title',
                        description: 'Category Description',
                        user_id: user.id)
  end

  before do
    user
  end

  context 'with associations' do
    it 'belongs to a user' do
      expect(Category.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it 'has many tasks' do
      expect(Category.reflect_on_association(:tasks).macro).to eq :has_many
    end
  end

  context 'with dependents' do
    let(:task) do
      Task.create(description: 'Task Descripton',
                  priority: Date.today,
                  user_id: user.id,
                  category_id: subject.id)
    end

    before do
      subject.save
      task
      subject.destroy
    end

    it 'deletes its tasks' do
      expect(Task.find_by(category_id: subject.id)).to eq nil
    end
  end

  context 'when initialized' do
    let(:subject_count) { Category.count }

    it 'counts to zero to begin with' do
      expect(subject_count).to eq 0
    end

    it 'counts to one after adding one' do
      subject.save
      expect(subject_count).to eq 1
    end
  end

  context 'with valid attributes' do
    it 'does validate' do
      expect(subject).to be_valid
    end
  end

  context 'without a title' do
    it 'does not validate' do
      subject.title = nil || ''
      expect(subject).to_not be_valid
    end
  end

  context 'when title is not unique' do
    before do
      Category.create(title: subject.title,
                      description: subject.description,
                      user_id: subject.user_id)
    end

    it 'does not validate' do
      subject.title = 'Category Title'
      expect(subject).to_not be_valid
    end
  end

  context 'without description' do
    it 'does not validate' do
      subject.description = nil
      expect(subject).to_not be_valid
    end
  end

  context 'when description is less than 10 characters' do
    it 'does not validate' do
      subject.description = 'A' * 9
      expect(subject).to_not be_valid
    end
  end

  context 'when description is more than 100 characters' do
    it 'does not validate' do
      subject.description = 'A' * 101
      expect(subject).to_not be_valid
    end
  end
end
