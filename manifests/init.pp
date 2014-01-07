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
class windows_puppet(
  $version    = hiera('windows_puppet','3.4.2'),
  $remoteUrl	= hiera('windows_puppet::remoteUrl','http://downloads.puppetlabs.com/windows/'),
  $installDir	= hiera('puppet-installDir','C:/software')){

    if $puppetversion != $version {
	  pget{'DownloadPuppet':
	    source  => "${remoteUrl}puppet-${version}.msi",
        target  => $installDir,
        notify  => Package['UpgradePuppet'],
      }
      package{'UpgradePuppet':
        description => 'Bogus Puppet Name to force installer',
        ensure  => installed,
        require => Pget['DownloadPuppet'],
        source  => "${installDir}/puppet-${version}.msi",
        install_options => ['/qn']
      }
    }
}
