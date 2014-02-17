# == Class: msv::dependencies
#
#
class msv::dependencies {

	anchor { 'msv::dependencies::begin': }
	anchor { 'msv::dependencies::end': }

	netinstall { 'libbson':
	  url => $::msv::params::libbson_repo,
	  extracted_dir => 'libbson-0.4.0',
	  destination_dir => '/tmp',
	  postextract_command => '/tmp/libbson-0.4.0/configure --enable-silent-rules && make && sudo make install'
	}

	netinstall { 'mongo-c-driver':
	  url => $::msv::params::libmongo_repo,
	  extracted_dir => 'mongo-c-driver-0.8.1',
	  destination_dir => '/tmp',
	  postextract_command => 'make && sudo make install'
	}

	exec { "config-mongo-c-driver":
	    command      => "echo /usr/local/lib > /etc/ld.so.conf.d/mongoc.conf",
	    provider     => "shell",
	    user         => "root",
	    require      => [
      						Netinstall["libbson"],
      						Netinstall["mongo-c-driver"],
    					],
    }

    exec { "apply-config-mono":
	    command      => "ldconfig",
	    provider     => "shell",
	    user         => "root",
	    require      => Exec["config-mongo-c-driver"],
	    before       => Anchor['msv::dependencies::end']
    }
}