package LembreseApi::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

LembreseApi::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched LembreseApi::Controller::Login in Login.');
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

	if ($username eq 'x' && $password eq 'x'){
		my $pid = 1;
		my $uid = $c->sessionid();
		$c->change_session_id;

		$c->session({
			uid => $uid,
			pid => $pid
		});

		$c->stash->{err} = 0;
		$c->stash->{msg} = 'You Are so Dumb login successfuly! For Real!';
		$c->stash->{jd} = {
			uid => $uid,
			pid => $pid
		};
	}else{
		$c->delete_session();
	}

	$c->forward('View::JSON');

}



sub error: Path('/login/error') : Args(0)  {
    my ( $self, $c ) = @_;

	$c->stash->{msg} = 'We can\'t find your session. Please re-login through our plugin.';
	$c->stash->{err} = 1;
	$c->stash->{jd} = {
		nouid => 1
	};
	$c->forward('View::JSON');

}


=head1 AUTHOR

renatosouza,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
