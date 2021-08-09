require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) do
    User.create(email: 'example@mail.com',
                password: 'password')
  end

  let(:category) do
    Category.create(title: 'Category Title',
                    description: 'Category Description',
                    user_id: user.id)
  end

  subject do
    described_class.new(description: 'Task Description',
                        priority: Date.today,
                        user_id: user.id,
                        category_id: category.id)
  end

  before do
    user
    category
  end

  context 'with associations' do
    it 'belongs to a user' do
      expect(Task.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it 'belongs to a category' do
      expect(Task.reflect_on_association(:category).macro).to eq :belongs_to
    end
  end

  context 'when initialized' do
    let(:subject_count) { Task.count }

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

  context 'without description' do
    it 'does not validate' do
      subject.description = nil
      expect(subject).to_not be_valid
    end
  end

  context 'when description is not unique' do
    before do
      Task.create(description: subject.description,
                  priority: subject.priority,
                  user_id: subject.user_id,
                  category_id: subject.category_id)
    end

    it 'does not validate' do
      subject.description = 'Task Description'
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

  context 'without priority date' do
    it 'does validate' do
      subject.priority = nil
      expect(subject).to be_valid
    end
  end

  context 'when priority date is in the past' do
    it 'does not validate' do
      subject.priority -= 10
      expect(subject).to_not be_valid
    end
  end
end
