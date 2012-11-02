require "spec_helper"

describe User do
  describe 'validation' do
    describe 'provider' do
      context 'when provider is nil' do
        let(:user) { build(:user, provider: nil) }
        it { expect(user.valid?).to be_false }
      end

      context 'when provider is empty' do
        let(:user) { build(:user, provider: '') }
        it { expect(user.valid?).to be_false }
      end

      context 'when provider is not permitted' do
        let(:user) { build(:user, provider: 'bitbucket') }
        it { expect(user.valid?).to be_false }
      end
    end

    describe 'name' do
      context 'when name is nil' do
        let(:user) { build(:user, name: nil) }
        it { expect(user.valid?).to be_false }
      end

      context 'when name is empty' do
        let(:user) { build(:user, name: '') }
        it { expect(user.valid?).to be_false }
      end

      context 'when name is too long' do
        let(:user) { build(:user, name: 'a' * 41) }
        it { expect(user.valid?).to be_false }
      end

      context 'when name is not unique' do
        let(:user) { build(:user, name: 'not_unique') }
        before { create(:user, name: 'not_unique')    }
        it { expect(user.valid?).to be_false }
      end
    end

    describe 'uid' do
      context 'when uid is nil' do
        let(:user) { build(:user, uid: nil) }
        it { expect(user.valid?).to be_false }
      end

      context 'when uid is empty' do
        let(:user) { build(:user, uid: '') }
        it { expect(user.valid?).to be_false }
      end

      context 'when uid is not numeric' do
        let(:user) { build(:user, uid: 'abc') }

        ### `uid` becomes `0` inspite of being inserted string. Why?
        it { expect(user.valid?).to be_true }
      end
    end

    describe 'image' do
      context 'when image is nil' do
        let(:user) { build(:user, image: nil) }
        it { expect(user.valid?).to be_false }
      end

      context 'when image is empty' do
        let(:user) { build(:user, image: '') }
        it { expect(user.valid?).to be_false }
      end

      context 'when image is permitted' do
        let(:user) { build(:user, image: 'abcde') }
        it { expect(user.valid?).to be_false}
      end
    end

    describe 'token' do
      context 'when valid' do
        context 'when token is nil' do
          let(:user) { build(:user, token: nil) }
          it { expect(user.valid?).to be_true }
        end

        context 'when token is empty' do
          let(:user) { build(:user, token: '') }
          it { expect(user.valid?).to be_true }
        end
      end

      context 'when invalid' do
        context 'when token is permitted' do
          let(:user) { build(:user, token: 'abcde') }
          it { expect(user.valid?).to be_false}
        end
      end
    end

    describe 'access_token' do
      context 'when valid' do
        context 'when access_token is nil' do
          let(:user) { build(:user, access_token: nil) }
          it { expect(user.valid?).to be_true }
        end

        context 'when access_token is empty' do
          let(:user) { build(:user, access_token: '') }
          it { expect(user.valid?).to be_true }
        end
      end

      context 'when invalid' do
        context 'when access_token is permitted' do
          let(:user) { build(:user, access_token: 'abcde') }
          it { expect(user.valid?).to be_false}
        end
      end
    end

    describe 'api_token' do
      context 'when valid' do
        context 'when api_token is nil' do
          let(:user) { build(:user, api_token: nil) }
          it { expect(user.valid?).to be_true }
        end

        context 'when api_token is empty' do
          let(:user) { build(:user, api_token: '') }
          it { expect(user.valid?).to be_true }
        end
      end

      context 'when invalid' do
        context 'when api_token is permitted' do
          let(:user) { build(:user, api_token: 'abcde') }
          it { expect(user.valid?).to be_false}
        end
      end
    end
  end
end
