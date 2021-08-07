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
