# == Class: msv
# This class provisioning the mongo-c-driver, libbson and replica_set_verifier service
#
# === Examples
#
#  class { msv:
#  }
#
#  or
#
#  include msv
#
# === Authors
#
# Johan Tique <johan.tique@codescrum.com>
#
# === Copyright
#
# Copyright 2014 Johan Tique.
#
class msv inherits msv::params{
    include msv::install

	anchor{ 'msv::begin':
		before => Anchor["msv::install::begin"],
	}

	anchor { 'msv::end': }

    file {
      "/etc/master_slave_verifier.conf":
        content => template('msv/master_set_verifier.conf.erb'),
        mode    => '0755',
        require => Class['msv::install'];
      "/etc/init.d/master_slave_verifier":
        content => template('msv/master_slave_verifier-init.conf.erb'),
        mode    => '0755',
        require => Class['msv::install'];
      "/etc/init.d/serviwer":
        content => template('msv/serviwer-init.conf.erb'),
        mode    => '0755',
        require => Class['msv::install'],
    }

    service { "master_slave_verifier":
      enable     => 'true',
      ensure     => 'running',
      hasstatus  => true,
      hasrestart => true,
      require    => [
        File["/etc/master_slave_verifier.conf", "/etc/init.d/master_slave_verifier"],
      ],
      before     => Anchor['msv::end']
    }

    service { "serviwer":
      enable     => 'true',
      ensure     => 'running',
      hasstatus  => true,
      hasrestart => true,
      require    => [
      File["/etc/init.d/serviwer"],
      ],
      before     => Anchor['msv::end']
    }
}
