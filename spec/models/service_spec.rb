require 'spec_helper'

describe Service do
  describe 'validation' do
    describe 'name' do
      context 'when invalid' do
        context 'when name is nil' do
          let(:service) { build(:service, name: nil) }
          it { expect(service.valid?).to be_false }
        end

        context 'when name is empty' do
          let(:service) { build(:service, name: '') }
          it { expect(service.valid?).to be_false }
        end

        context 'when name is too long' do
          let(:service) { build(:service, name: 'a' * 101) }
          it { expect(service.valid?).to be_false }
        end

        context 'when name is not unique' do
          let(:service) { build(:service) }
          before { create(:service, name: service.name) }
          it { expect(service.valid?).to be_false }
        end
      end
    end

    describe 'description' do
      context 'when valid' do
        context 'when description is nil' do
          let(:service) { build(:service, description: nil) }
          it { expect(service.valid?).to be_true }
        end

        context 'when description is empty' do
          let(:service) { build(:service, description: '') }
          it { expect(service.valid?).to be_true }
        end
      end

      context 'when invalid' do
        context 'when description is too long' do
          let(:service) { build(:service, description: 'a' * 256) }
          it { expect(service.valid?).to be_false }
        end
      end
    end

    describe 'munin_url' do
      context 'when valid' do
        context 'when munin_url is nil' do
          let(:service) { build(:service, munin_url: nil) }
          it { expect(service.valid?).to be_true }
        end

        context 'when munin_url is empty' do
          let(:service) { build(:service, munin_url: '') }
          it { expect(service.valid?).to be_true }
        end
      end

      context 'when invalid' do
        context 'when munin_url is not a URL' do
          let(:service) { build(:service, munin_url: 'Not a URL') }
          it { expect(service.valid?).to be_false }
        end
      end
    end
  end

  describe '#role_with_hosts' do
    let(:host1)     { create(:host, :with_relations, count: 1) }
    let(:host2)     { create(:host) }
    let(:host3)     { create(:host) }
    let(:role1)     { host1.roles.first    }
    let(:role2)     { create(:role) }
    let(:service1)  { host1.services.first }
    let(:service2)  { create(:service) }

    let!(:relation1) { create(:host_relation, service_id: service1.id, role_id: role1.id, host_id: host2.id) }
    let!(:relation2) { create(:host_relation, service_id: service2.id, role_id: role2.id, host_id: host1.id) }
    let!(:relation3) { create(:host_relation, service_id: service2.id, role_id: role1.id, host_id: host3.id) }

    it {
      role  = service1.roles_with_hosts.keys.first
      hosts = service1.roles_with_hosts[role]

      expect(role).to be  == role1
      expect(hosts).to be == [host1, host2]
    }
  end

  describe '#munin_url_for_service' do
    let(:service) { create(:service) }

    it {
      expect(service.munin_url_for_service).to be_a_kind_of URI
      expect(service.munin_url_for_service.to_s).to be == service.munin_url << URI.escape(service.name)
    }
  end

  describe '#munin_url_for_service_and' do
    context 'when both role and host are passed' do
      let(:host)    { create(:host, :with_relations, count: 3) }
      let(:service) { host.services.first }
      let(:role)    { host.roles.first    }

      it {
        expect(service.munin_url_for_service_and(role: role, host: host)).to be_a_kind_of URI
        expect(service.munin_url_for_service_and(role: role, host: host).to_s).to be == service.munin_url << [service.name, role.name, host.name].map { |n| URI.escape(n) }.join('/')
      }
    end

    context 'when both role and host are not passed' do
      let(:service) { create(:service) }

      it {
        expect { service.munin_url_for_service_and(role: nil, host: nil) }.to raise_error(ArgumentError)
      }
    end
  end

  describe '#munin_url_for_graph_of' do
    context 'when both role and host are passed' do
      let(:host)    { create(:host, :with_relations, count: 3) }
      let(:service) { host.services.first }
      let(:role)    { host.roles.first    }

      it {
        expect(service.munin_url_for_graph_of(role: role, host: host)).to be_a_kind_of URI
        expect(service.munin_url_for_graph_of(role: role, host: host).to_s).to be == service.munin_url << [service.name, role.name, host.name, 'load-day.png'].map { |n| URI.escape(n) }.join('/')
      }
    end

    context 'when both role and host are not passed' do
      let(:service) { create(:service) }

      it {
        expect { service.munin_url_for_graph_of(role: nil, host: nil) }.to raise_error(ArgumentError)
      }
    end
  end
end
