require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { described_class.new }

  let :existing_category do
    described_class.create(
      title: 'not a unique title',
      description: 'description'
    )
  end

  let(:category_on_tasks) { Category.reflect_on_association(:tasks).macro }

  context 'When title is not present' do
    context 'It is nil' do
      it do
        subject.title = nil
        expect(subject).to_not be_valid
      end
    end

    context 'It is an empty string' do
      it do
        subject.title = ''
        expect(subject).to_not be_valid
      end
    end
  end

  context 'When title is not unique' do
    it do
      existing_category
      subject.title = 'not a unique title'
      expect(subject).to_not be_valid
    end
  end

  context 'When title is unique' do
    it do
      subject.title = 'unique title'
      expect(subject).to_not be_valid
    end
  end

  context 'When description is not present' do
    context 'It is nil' do
      it do
        subject.description = nil
        expect(subject).to_not be_valid
      end
    end

    context 'It is an empty string' do
      it do
        subject.description = ''
        expect(subject).to_not be_valid
      end
    end
  end

  context 'When description is shorter than minimum' do
    it do
      subject.description = 'a' * 9
      expect(subject).to_not be_valid
    end
  end

  context 'When description is longer than maximum' do
    it do
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
    it 'has many tasks' do
      expect(category_on_tasks).to eq :has_many
    end
  end
end
