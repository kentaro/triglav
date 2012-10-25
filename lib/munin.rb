require 'uri'

class Munin
  class Error < StandardError; end

  attr_accessor :service

  def initialize (service = nil)
    @service = service
  end

  def root
    raise Error, 'No service defined'   unless service
    raise Error, 'No munin_url defined' unless service.munin_url.present?

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
    found = nil

    if service && service.munin_url.present?
      found = service
    else
      host.services.each do |service|
        if service.munin_url.present?
          found = service
          break
        end
      end
    end

    found
  end

  def categories
    CATEGORIES
  end

  CATEGORIES = [
    {
      name: 'Disk',
      sub_categories: [
        {
          name: 'Disk IOs per device',
          type: 'diskstats_iops'
        },
        {
          name: 'Disk latency per device',
          type: 'diskstats_latency',
        },
        {
          name: 'Disk throughput per device',
          type: 'diskstats_throughput',
        },
        {
          name: 'Disk usage in percent',
          type: 'df',
        },
        {
          name: 'Disk utilization per device',
          type: 'diskstats_utilization',
        },
        {
          name: 'Filesystem usage (in bytes)',
          type: 'df_abs',
        },
        {
          name: 'Inode usage in percent',
          type: 'df_inode',
        },
        {
          name: 'IO Service time',
          type: 'iostat_ios',
        },
        {
          name: 'IOstat',
          type: 'iostat',
        },
      ],
    },
    {
      name: 'Network',
      sub_categories: [
        {
          name: 'eth0 errors',
          type: 'if_err_eth0',
        },
        {
          name: 'eth0 traffic',
          type: 'if_eth0',
        },
        {
          name: 'Firewall Throughput',
          type: 'fw_packets',
        },
        {
          name: 'HTTP loadtime of a page',
          type: 'http_loadtime',
        },
        {
          name: 'Netstat',
          type: 'netstat',
        },
     ],
    },
    {
      name: 'Processes',
      sub_categories: [
        {
          name: 'Fork rate',
          type: 'forks',
        },
        {
          name: 'Number of threads',
          type: 'threads',
        },
        {
          name: 'Processes',
          type: 'processes',
        },
        {
          name: 'Processes priority',
          type: 'proc_pri',
        },
        {
          name: 'VMstat',
          type: 'vmstat',
        },
      ],
    },
    {
      name: 'System',
      sub_categories: [
        {
          name: 'Available entropy',
          type: 'entropy',
        },
        {
          name: 'CPU usage',
          type: 'cpu',
        },
        {
          name: 'Extended memory usage',
          type: 'memory_ext',
        },
        {
          name: 'File table usage',
          type: 'open_files',
        },
        {
          name: 'Individual interrupts',
          type: 'irqstats',
        },
        {
          name: 'Inode table usage',
          type: 'open_inodes',
        },
        {
          name: 'Interrupts and context switches',
          type: 'interrupts',
        },
        {
          name: 'Load average',
          type: 'load',
        },
        {
          name: 'Logged in users',
          type: 'users',
        },
        {
          name: 'Memory usage',
          type: 'memory',
        },
        {
          name: 'Swap in/out',
          type: 'swap',
        },
        {
          name: 'Uptime',
          type: 'uptime',
        },
      ]
    },
    {
      name: 'time',
      sub_categories: [
        {
          name: 'NTP kernel PLL estimated error (secs)',
          type: 'ntp_kernel_err',
        },
        {
          name: 'NTP kernel PLL frequency (ppm + 0)',
          type: 'ntp_kernel_pll_freq',
        },
        {
          name: 'NTP kernel PLL offset (secs)',
          type: 'ntp_kernel_pll_off',
        },
        {
          name: 'NTP timing statistics for system peer',
          type: 'ntp_offset',
        }
      ],
    },
  ]
end
