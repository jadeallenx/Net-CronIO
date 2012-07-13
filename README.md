# NAME

Net::CronIO - Perl binding for cron.io

# VERSION

version 0.01

# SYNOPSIS

    use 5.014;
    use Net::CronIO;

    my $cron = Net::CronIO->new(
        api_username => 'example',
        api_password => 'sekrit',
    );

    my $newjob = $cron->create_cron(
        name => 'Daily clean up job',
        url => 'http://example.com/blahblah/?cleanup=1',
        schedule => '46 0 * * *',
    );

    my $jobs = $cron->get_all_crons();

    foreach my $job ( $jobs ) {
        if ( $job->{'url'} =~ /deadhost.com/ ) {
            $cron->update_cron(
              id => $job->{'id'},
              url => $job->{'url'} =~ s/deadhost\.com/example\.com/r,
            );
        }
    }
    

    say "deleted" if ( $cron->delete_cron( id => $jobs->[0]->{'id'} ) );

This is a Perl binding for the [cron.io](http://cron.io) service.  Cron is a Unix service which
executes jobs on a periodic basis. The cron.io service contacts URLs using the same
time period specification.

At the moment, the only way to generate a username and password for the service is by making 
a call on the `create_user()` method.  Email verification is required before the 
credentials are valid.

I think you're a silly person.

# ATTRIBUTES

## api_username

You must supply an `api_username` for every method except `create_user()`.  This can be done at
object construction time, or later by calling the `api_username()` method.

## api_password

You must supply an `api_password` for every method except `create_user()`.  This can be done at
object construction time, or later by calling the `api_username()` method.

# METHODS

## create_user()

This method requires the following parameters: `email`, `username`, `password`. This call will register
a username/password with the service.  Human intervention (in the form of an email verification) is required
before your username/password are activated.

Once these credentials are active, you must provide them to this binding to execute other methods.

The return value is a string message provided by the API service (which evaluates to
a true value in Perl.)  This method dies on errors.

## get_all_crons()

This method returns an arrayref containing hashes of all cron jobs for your username.

Hashes will contain the following keys:

- `id`

This is an internal ID used by the service to identify a specific cron job.  It is a required
parameter for most of the other methods.

- `name`

This is the name you assigned to a specific job.

- `url`

The URL to contact at the given schedule specification.

- `schedule`

This is a standard Unix cron style specification.  See [cron](http://en.wikipedia.com/wiki/Cron) on Wikipedia
for a verbose description of this format.

It is possible this call will return a reference to an empty list.

## create_cron()

This method creates a new job.  Required parameters are `name`, `url`, `schedule`.

The return value is a hash of `id`, plus the three params you provided.

## get_cron()

This method retrieves a specific job by its `id`.  `id` is a required parameter for this
method.  The return value is a hash as described above.

## update_cron()

This method changes values with jobs which already have ids. `id` is a required parameter.
Optional parameters are any or all of `name`, `url`, and/or `schedule`.

## delete_cron()

This method removes a job from the service. `id` is a required parameter.  On success, this
method returns a true value.  It dies on errors.

# TESTING NOTE

To execute the full test suite, you must set CRONIO_API_USERNAME and CRONIO_API_PASSWORD environment 
variables with valid credentials.

# AUTHOR

Mark Allen <mrallen1@yahoo.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Mark Allen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.