package LembreseApi::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

LembreseApi::Controller::Root - Root Controller for LembreseApi

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    $c->response->body( $c->welcome_message );
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}


sub bookmarkit: Path('/bookmarkit'):Args(0) {
	my ( $self, $c ) = @_;

	my $params = $c->request->params;

	$c->stash->{msg} = 'ok';
	$c->stash->{err} = 0;
	$c->stash->{jd} = {};

	if ($params->{url} eq 'chrome://extensions/'){
		$c->stash->{err} = 1;
		$c->stash->{jd}{nouid}=1;
		$c->stash->{msg} = 'pid invalid! please re-login';

	}

	$c->forward('View::JSON');


}


=head2 auto

Check if there is a user.

=cut

# Note that 'auto' runs after 'begin' but before your actions and that
# 'auto's "chain" (all from application path to most specific class are run)
# See the 'Actions' section of 'Catalyst::Manual::Intro' for more info.
sub auto :Private {
	my ($self, $c) = @_;
	if ($c->controller eq $c->controller('Login') ) {
		return 1;
	}

	my $params = $c->request->params;
	my $param_uid   = "$params->{pid}|$params->{uid}";
	my $session_uid = $c->session->{pid} . '|' . $c->session->{uid};

	if ($param_uid ne $session_uid) {

		# Dump a log message to the development server debug output
		$c->log->debug("***Root::auto User not found, forwarding to /login/error: param: $param_uid, session: $session_uid");
		# Redirect the user to the login page
		$c->response->redirect($c->uri_for('/login/error'));
		# Return 0 to cancel 'post-auto' processing and prevent use of application
		return 0;
	}

	# User found, so return 1 to continue with processing after this 'auto'
	return 1;
}



=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

renatosouza,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
