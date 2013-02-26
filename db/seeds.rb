# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w(triglav hyperion).each do |name|
  Service.create(name: name)
end

%w(app db).each do |name|
  Role.create(name: name)
end

[%w(foo 1), %w(bar 0), %w(baz 1) ].each do |host|
  Host.create(name: host[0], active: host[1])
end
