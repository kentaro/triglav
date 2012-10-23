require 'spec_helper'

describe Service do
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
