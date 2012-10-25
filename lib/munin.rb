require 'uri'

class Munin
  class Error < StandardError; end

  attr_accessor :service

  def initialize (service = nil)
    @service = service
  end

  def root
    raise Error, 'No service defined' unless service
    URI.parse(service.munin_url)
  end

  def service_url
    url = root
    url += URI.escape(service.name)
    url
  end

  def url_for (args)
    host = args[:host]
    role = args[:role] || host.roles.first
    self.service ||= find_service_that_hash_munin_url_by(host)

    url  = root
    path = [service, role, host].map { |p| URI.escape(p.name) }.join('/')
    url += path
  end

  def graph_url_for (args)
    host    = args[:host]
    role    = args[:role]
    url     = url_for(role: role, host: host)
    options = { type: :load, span: :day}.merge(args[:options] || {})

    path = [url.path, URI.escape("#{options[:type].to_s}-#{options[:span].to_s}.png")].join('/')
    url += path
  end

  def find_service_that_hash_munin_url_by (host)
    if service
      service.munin_url && service
    else
      host.services.each do |service|
        if service.munin_url
          return service
        end
      end
    end
  end
end
