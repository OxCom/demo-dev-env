class services::nginx (
    Array $versions = $services::nginx::params::versions,
    Hash $projects  = $services::nginx::params::projects,
    String $domain  = $services::nginx::params::domain
) inherits services::nginx::params {
    info("Initialize")

    require services::nginx::package

    class { 'services::nginx::php_fpm':
        versions => $versions,
        projects => $projects
    }

    class { 'services::nginx::www':
        versions => $versions,
        projects => $projects,
        domain   => $domain,
    }

    file { "/etc/nginx/nginx.conf":
        notify  => Service["nginx"],
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => epp("services/nginx/nginx.conf.epp"),
        require => Service["nginx"]
    }

    info("Generate snippets")
    file { '/etc/nginx/snippets':
        ensure  => 'directory',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['nginx-full']
    }

    info("[Snippet]: SSL")
    file { '/etc/nginx/snippets/ssl.conf':
        ensure  => file,
        content => template('services/nginx/snippet/ssl.conf.erb'),
        notify  => Service["nginx"],
        owner   => 'root',
        group   => 'root',
        require => [
            File['/etc/nginx/snippets']
        ]
    }

    info("[Snippet]: GZip")
    file { '/etc/nginx/snippets/gzip.conf':
        ensure  => file,
        content => template('services/nginx/snippet/gzip.conf.erb'),
        notify  => Service["nginx"],
        owner   => 'root',
        group   => 'root',
        require => [
            File['/etc/nginx/snippets']
        ]
    }

    info("[Snippet]: Static")
    file { '/etc/nginx/snippets/static.conf':
        ensure  => file,
        content => template('services/nginx/snippet/static.conf.erb'),
        notify  => Service["nginx"],
        owner   => 'root',
        group   => 'root',
        require => [
            File['/etc/nginx/snippets']
        ]
    }
}
