require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new }

  let :existing_user do
    described_class.create(
      email_address: 'not.unique@example.com',
      password: 'password',
      username: 'username'
    )
  end

  context 'When email address is not present' do
    context 'It is nil' do
      it do
        subject.email_address = nil
        expect(subject).to_not be_valid
      end
    end

    context 'It is an empty string' do
      it do
        subject.email_address = ''
        expect(subject).to_not be_valid
      end
    end
  end

  context 'When email address is not unique' do
    it do
      existing_user
      subject.email_address = 'not.unique@example.com'
      expect(subject).to_not be_valid
    end
  end

  context 'When email address is unique' do
    it do
      subject.email_address = 'unique@example.com'
      expect(subject).to_not be_valid
    end
  end

  context 'When password is not present' do
    context 'It is nil' do
      it do
        subject.password = nil
        expect(subject).to_not be_valid
      end
    end

    context 'It is an empty string' do
      it do
        subject.password = ''
        expect(subject).to_not be_valid
      end
    end
  end

  context 'When password is shorter than minimum' do
    it do
      subject.password = 'a' * 9
      expect(subject).to_not be_valid
    end
  end

  context 'When username is not present' do
    context 'It is nil' do
      it do
        subject.username = nil
        expect(subject).to_not be_valid
      end
    end

    context 'It is an empty string' do
      it do
        subject.username = ''
        expect(subject).to_not be_valid
      end
    end
  end

  context 'When username is present' do
    it do
      subject.username = 'username'
      expect(subject).to be_valid
    end
  end

end
