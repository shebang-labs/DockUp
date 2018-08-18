# DockUp Development

This is for anyone interested in contributing to DockUp project.

## Environment

### System

    git
    rvm

### Ruby

The safest bet is to use [rvm](https://github.com/wayneeseguin/rvm) with an rvm
installed ruby (not system ruby) and a clean gemset dedicated to dockup:

    rvm 2.5.1@dockup --create # or whatever version of Ruby you prefer

[rbenv](https://github.com/sstephenson/rbenv) is also supported.

Windows users can use [uru](https://bitbucket.org/jonforums/uru).

If you use a different Ruby version manager (or none at all), the important
thing is that you have a sandboxed gem environment that does not require you to
use sudo to install gems, and has no dockup libraries installed.

### Bundler

Bundler is required for dependency management. Install it first:

    gem install bundler

### DockUp dev

Once all of the pre-reqs above are taken care of, run these steps to get
bootstrapped:

    git clone git@github.com:tareksamni/DockUp.git
    cd DockUp
    bundle install
    bundle exec rspec

If all goes well, you'll end up seeing a lot of passing rspec code examples.

You need to set following env variables (using S3 for ex.) to be able to run the app (rake tasks):

``` bash

export AWS_ACCESS_KEY_ID=some_secret_id
export AWS_SECRET_ACCESS_KEY=some_secret_key
export AWS_REGION=some_s3_region
export AWS_BUCKET=some_s3_bucket
```

Run `rake -T` to see the available tasks.

## Contributing

Once you've set up the environment. From there you can run the specs, and make patches.

## Patches

Please submit a pull request or a github issue to one of the issue trackers
listed below. If you submit an issue, please include a link to either of:

* a gist (or equivalent) of the patch
* a branch or commit in your github fork of the repo

## Issues

* [https://github.com/tareksamni/DockUp/issues](https://github.com/tareksamni/DockUp/issues)
