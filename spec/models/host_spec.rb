require 'spec_helper'

describe Host do
  describe 'validation' do
    describe 'name' do
      context 'when invalid' do
        context 'when name is nil' do
          let(:host) { build(:host, name: nil) }
          it { expect(host.valid?).to be_false }
        end

        context 'when name is empty' do
          let(:host) { build(:host, name: '') }
          it { expect(host.valid?).to be_false }
        end

        context 'when name is too long' do
          let(:host) { build(:host, name: 'a' * 101) }
          it { expect(host.valid?).to be_false }
        end

        context 'when name is not unique' do
          let(:host) { build(:host) }
          before { create(:host, name: host.name) }
          it { expect(host.valid?).to be_false }
        end

        context 'when name contains /' do
          let(:host) { build(:host, name: '</script>') }
          it { expect(host.valid?).to be_false }
        end
      end
    end

    describe 'ip_address' do
      context 'when valid' do
        context 'when ip_address is nil' do
          let(:host) { build(:host, ip_address: nil) }
          it { expect(host.valid?).to be_true }
        end

        context 'when ip_address is empty' do
          let(:host) { build(:host, ip_address: '') }
          it { expect(host.valid?).to be_true }
        end
      end

      context 'when invalid' do
        context 'when ip_address is invalid' do
          let(:host) { build(:host, ip_address: 'Invalid IP Address') }
          it { expect(host.valid?).to be_false }
        end
      end
    end

    describe 'description' do
      context 'when valid' do
        context 'when description is nil' do
          let(:host) { build(:host, description: nil) }
          it { expect(host.valid?).to be_true }
        end

        context 'when description is empty' do
          let(:host) { build(:host, description: '') }
          it { expect(host.valid?).to be_true }
        end
      end

      context 'when invalid' do
        context 'when description is too long' do
          let(:host) { build(:host, description: 'a' * 256) }
          it { expect(host.valid?).to be_false }
        end
      end
    end
  end
end
