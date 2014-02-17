# == Class: msv::install
#
#
class msv::install {
    include msv::dependencies

	anchor { 'msv::install::begin':
	  before => Anchor['msv::dependencies::begin'],
	}

    anchor { 'msv::install::end': }

	netinstall { 'msv':
	  url => $::msv::params::msv_repo,
	  extracted_dir => 'master_slave_verifier-0.1.0',
	  destination_dir => '/tmp',
	  postextract_command => 'make && sudo make install',
      require => Anchor['msv::dependencies::end']
	}
}