package LembreseApi;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple

	Session
	Session::Store::FastMmap
    Session::State::Cookie

/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in lembreseapi.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.


__PACKAGE__->config('Plugin::Session' => {
	expires           => 3600 * 24 * 2, # 2 meses
	verify_address    => 1,             # se mudar o IP cai
	verify_user_agent => 1,             # o user-agent tambem
});

__PACKAGE__->config(
    name => 'LembreseApi',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
);
 


__PACKAGE__->config({
      'View::JSON' => {
          allow_callback  => 1,    # defaults to 0
          callback_param  => 'cb', # defaults to 'callback'
          expose_stash    => [ qw(msg err jd) ], # defaults to everything
      },
});


# Start the application
__PACKAGE__->setup();


=head1 NAME

LembreseApi - Catalyst based application

=head1 SYNOPSIS

    script/lembreseapi_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<LembreseApi::Controller::Root>, L<Catalyst>

=head1 AUTHOR

renatosouza,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
