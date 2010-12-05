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

=head2 login

do login using cache
=cut
sub login: Path('/login') :Args(0) {
    my ( $self, $c ) = @_;

	# Get the username and password from form
	my $username = $c->request->params->{u};
	my $password = $c->request->params->{p};

	$c->stash->{msg} = 'user name or password invalid';
	$c->stash->{err} = 1;
	$c->stash->{jd} = {};
 
	if ($username eq 'youaresodumb' && $password eq 'forreal'){
		$c->stash->{err} = 0;
		$c->stash->{msg} = 'You Are so Dumb login successfuly! For Real!';
		$c->stash->{jd} = {
			uid => '12345',
			pid => '67890'
		};
	}

	$c->forward('View::JSON');

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
