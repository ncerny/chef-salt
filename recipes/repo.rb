#
# Cookbook Name:: chef-salt
# Recipe:: repo
#
# Copyright (C) 2016, Grant Ridder
# Copyright (C) 2014, Daryl Robbins
#
#
#

version = node['salt']['version'].split('-')[0]
archive = if version.include?('.')
  v = ::Gem::Version.new(version)
  l = v.segments.length
  l = l - 1 if v.segments[0] < 3000
  l.eql?(2)
end
version = "archive/#{version}" if archive

case node['platform_family']
when 'debian'
  repo_uri = "https://repo.saltstack.com/apt/#{node['platform']}/#{node['lsb']['release']}/#{node['packages']['apt']['arch']}/#{version}"

  apt_repository 'saltstack-salt' do
    uri          repo_uri
    distribution node['lsb']['codename']
    components   ['main']
    key          "#{repo_uri}/SALTSTACK-GPG-KEY.pub"
  end
when 'rhel'
  yum_repository 'saltstack-repo' do
    description 'SaltStack repo for Red Hat Enterprise Linux $releasever'
    baseurl "https://repo.saltstack.com/yum/redhat/$releasever/$basearch/#{version}"
    gpgkey "https://repo.saltstack.com/yum/redhat/$releasever/$basearch/#{version}/SALTSTACK-GPG-KEY.pub"
    action :create
  end
end
