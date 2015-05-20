# == Class: windows_puppet
#
# Full description of class windows_puppet here.
#
# === Parameters
#
# Document parameters here.
#
# [*version*]
# Tell the desired remote version to be installed
#
# [*remoteUrl*]
# Remote base url to retrieve puppet-$version.msi from
#
# [*master*]
# Specify the puppet master server.  Defaults to puppet.
#
# === Examples
#
#  class { windows_puppet:
#    version => '3.4.1',
#    remoteUrl => 'http://downloads.puppetlabs.com/windows/',
#    installDir=> 'C:/software'
#  }
#
# === Authors
#
# Author Name Travis Fields
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class windows_puppet (
  $version    = hiera('windows_puppet::version', '3.7.1'),
  $remoteUrl  = hiera('windows_puppet::remoteUrl', 'http://downloads.puppetlabs.com/windows/'),
  $installDir = hiera('windows_puppet::installDir', 'C:\software'),
  $master     = hiera('windows_puppet::master', 'puppet')) {
  if $puppetversion != $version {
    file { $installDir:
      ensure  => directory,
      recurse => true
    }
    
    
    if($architecture == 'x64' and $version >= '3.7.0') {
      $source = "puppet-${version}-x64.msi"
    } else {
      $source = "puppet-${version}.msi"
    }

    pget { 'DownloadPuppet':
      source  => "${remoteUrl}${source}",
      target  => $installDir,
      require => File[$installDir]
    }

    package { 'UpgradePuppet':
      name            => 'Puppet',
      ensure          => "${version}",
      require         => Pget['DownloadPuppet'],
      source          => "${installDir}\\${source}",
      install_options => ["PUPPET_MASTER_SERVER=${master}"]
    }
  }
}
