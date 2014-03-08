# Installs a ruby version with ruby-build..
# Takes ensure, env, and version params.
#
# Usage:
#
#     ruby::version { '1.9.3-p194': }

define ruby::version(
  $ensure  = 'installed',
  $env     = {},
  $version = $name
) {
  require ruby

  $alias_hash = hiera_hash('ruby::version::alias', {})

  if has_key($alias_hash, $version) {
    $to = $alias_hash[$version]

    ruby::alias { $version:
      to => $to,
    }
  } else {

    case $version {
      /jruby/: { require 'java' }
      default: { }
    }

    $default_env = {
      'CC' => '/usr/bin/cc',
    }

    if $::operatingsystem == 'Darwin' {
      require xquartz
      include homebrew::config
      include boxen::config
    }

    $hierdata = hiera_hash('ruby::version::env', {})

    if has_key($hierdata, $::operatingsystem) {
      $os_env = $hierdata[$::operatingsystem]
    } else {
      $os_env = {}
    }

    if has_key($hierdata, $version) {
      $version_env = $hierdata[$version]
    } else {
      $version_env = {}
    }

    $_env = merge(merge(merge($default_env, $os_env), $version_env), $env)

    if has_key($_env, 'CC') and $_env['CC'] =~ /gcc/ {
      require gcc
    }

    ensure_resource('file', "${ruby::prefix}/rubies", {
      'ensure' => 'directory',
      'owner'  => $user,
    })

    ruby { $version:
      ensure      => $ensure,
      environment => $_env,
      prefix      => "${ruby::prefix}/rubies/${version}",
      ruby_build  => "${ruby::prefix}/ruby-build/bin/ruby-build",
      user        => $ruby::user,
      provider    => rubybuild,
    }

  }

}
