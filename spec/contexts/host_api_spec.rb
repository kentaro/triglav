require 'spec_helper'

describe HostApiContext do
  describe '#index' do
    let!(:host1)  { create(:host, :with_relations, count: 2) }
    let!(:host2)  { create(:host, :with_relations, count: 2) }
    let(:context) { HostApiContext.new }

    it {
      hosts = context.index

      expect(hosts.count).to be == 2
      hosts.each do |host|
        expect(host).to be_a_kind_of(HostApiContext::Embeddable)
      end

      expect(hosts[0].services.count).to be == 2
      expect(hosts[0].roles.count).to be    == 2
      expect(hosts[1].services.count).to be == 2
      expect(hosts[1].roles.count).to be    == 2
    }
  end

  describe '#show' do
    let!(:host)   { create(:host, :with_relations, count: 2) }
    let(:context) { HostApiContext.new(host: host) }

    it {
      host = context.show

      expect(host).to be_a_kind_of(HostApiContext::Embeddable)
      expect(host.services.count).to be == 2
      expect(host.roles.count).to be    == 2
    }
  end

  describe '#hosts_of' do
    let!(:host1)   { create(:host)    }
    let!(:host2)   { create(:host)    }
    let!(:service) { create(:service) }
    let!(:role1)   { create(:role)    }
    let!(:role2)   { create(:role)    }
    let!(:relation1) {
      create(:host_relation, host_id: host1.id, service_id: service.id, role_id: role1.id)
    }
    let!(:relation2) {
      create(:host_relation, host_id: host1.id, service_id: service.id, role_id: role2.id)
    }
    let!(:relation3) {
      create(:host_relation, host_id: host2.id, service_id: service.id, role_id: role1.id)
    }

    let(:context) { HostApiContext.new }

    context 'when service and host are passed' do
      it {
        expect(context.hosts_of(service, role1).count).to be == 2
        expect(context.hosts_of(service, role2).count).to be == 1
      }
    end

    context 'when only service is passed' do
      it {
        expect(context.hosts_of(service).count).to be == 2
      }
    end
  end
end
