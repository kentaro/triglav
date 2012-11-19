require 'spec_helper'

describe Role do
  describe 'validation' do
    describe 'name' do
      context 'when invalid' do
        context 'when name is nil' do
          let(:role) { build(:role, name: nil) }
          it { expect(role.valid?).to be_false }
        end

        context 'when name is empty' do
          let(:role) { build(:role, name: '') }
          it { expect(role.valid?).to be_false }
        end

        context 'when name is too long' do
          let(:role) { build(:role, name: 'a' * 101) }
          it { expect(role.valid?).to be_false }
        end

        context 'when name is not unique' do
          let(:role) { build(:role) }
          before { create(:role, name: role.name) }
          it { expect(role.valid?).to be_false }
        end

        context 'when name contains /' do
          let(:role) { build(:role, name: '</script>') }
          it { expect(role.valid?).to be_false }
        end
      end
    end

    describe 'description' do
      context 'when valid' do
        context 'when description is nil' do
          let(:role) { build(:role, description: nil) }
          it { expect(role.valid?).to be_true }
        end

        context 'when description is empty' do
          let(:role) { build(:role, description: '') }
          it { expect(role.valid?).to be_true }
        end
      end

      context 'when invalid' do
        context 'when description is too long' do
          let(:role) { build(:role, description: 'a' * 256) }
          it { expect(role.valid?).to be_false }
        end
      end
    end
  end
end
