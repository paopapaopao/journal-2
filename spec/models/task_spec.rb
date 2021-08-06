require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:category_create) do
    Category.create(title: 'Category Title',
                    description: 'Category Description')
  end

  before :each do
    category_create
  end

  subject do
    described_class.new
  end

  let :existing_category do
    described_class.create(
      description: 'description',
      category_id: category_create.id
    )
  end

  let(:task_on_category) { Task.reflect_on_association(:category).macro }

  context 'When description is not present' do
    context 'It is nil' do
      it 'Invalid' do
        subject.description = nil
        expect(subject).to_not be_valid
      end
    end

    context 'It is an empty string' do
      it 'Invalid' do
        subject.description = ''
        expect(subject).to_not be_valid
      end
    end
  end

  context 'When description is shorter than minimum' do
    it 'Invalid' do
      subject.description = 'a' * 9
      expect(subject).to_not be_valid
    end
  end

  context 'When description is longer than maximum' do
    it 'Invalid' do
      subject.description = 'a' * 101
      expect(subject).to_not be_valid
    end
  end

  context 'When description is between minimum and maximum' do
    it 'Valid' do
      subject.description = 'a' * 50
      expect(subject).to be_valid
    end
  end

  context 'with associations' do
    it 'belongs to a category' do
      expect(task_on_category).to eq :belongs_to
    end
  end
end
