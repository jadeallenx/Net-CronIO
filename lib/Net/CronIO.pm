use strict;
use warnings;
package Net::CronIO;

use Net::HTTP::API;
use Carp qw(croak);

net_api_declare cronio => (
    api_base_url    => 'http://api.cron.io/v1',
    api_format      => 'json',
    api_format_mode => 'content-type',
    authentication  => 1,
);

net_api_method create_user => (
    description => "Sign up for service and get a username/password",
    method => "POST",
    path => '/users',
    params => [qw(email username password)],
    required => [qw(email username password)],
    expected => [qw(201)],
);

net_api_method get_all_crons => (
    description => "List all the crons you have. Requires authentication.",
    method => "GET",
    path => '/crons',
    authentication => 1,
);

net_api_method create_cron => (
    description => "Create a new cron entry for your account. Requires authentication.",
    method => "POST",
    path => '/crons',
    params => [qw(name url schedule)],
    required => [qw(name url schedule)],
    authentication => 1,
);

net_api_method get_cron => (
    description => "List a specific cron entry. Requires a cron id and authentication.",
    method => "GET",
    path => '/crons/:id',
    params => [qw(id)],
    required => [qw(id)],
    authentication => 1,
);

net_api_method update_cron => (
    description => "Update a cron entry. Requires cron id and authentication.",
    method => "PUT",
    path => '/crons/:id',
    params => [qw(id name url schedule)],
    required => [qw(id)],
    authentication => 1,
);

net_api_method delete_cron => (
    descripton => "Delete a cron entry. Requires cron id and authentication.",
    method => "DELETE",
    path => '/crons/:id',
    params => [qw(id)],
    required => [qw(id)],
    expected => [qw(204)],
    authentication => 1,
);

around 'delete_cron' => sub {
    my $orig = shift;
    my $self = shift;

    my ($content, $response) = $self->$orig(@_);

    if ( $response->is_success ) {
        return 1;
    }
    else {
        croak $response->status_line;
    }
};

around 'create_user' => sub {
    my $orig = shift;
    my $self = shift;

    my ($content, $response) = $self->$orig(@_);

    if ( $response->is_success ) {
        return $content->{'message'};
    }
    else {
        croak $response->status_line . ": " . $response->content;
    }
};

1;
