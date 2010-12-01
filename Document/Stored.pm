package Document::Stored;


use 5.010;
use Data::Dumper;

use Moose;
use Moose::Util::TypeConstraints;

use JSON::Any;
use MongoDB;
use WWW::Mechanize;

our $VERSION = '0.01';

has 'url'      => ( is => 'ro', isa => 'Str' );
has 'user'     => ( is => 'rw', isa => 'Str' );
has 'pass'     => ( is => 'rw', isa => 'Str' );
has 'ip'       => ( is => 'rw', isa => 'Str' );
has 'date'     => ( is => 'rw', isa => 'DateTime' );
has 'comment'  => ( is => 'rw', isa => 'Str' );
has 'highlight'=> ( is => 'rw', isa => 'Str' );

has 'browser'  => ( is => 'rw', isa => 'WWW::Mechanize' );

has 'jsdocUsr' => ( is => 'rw', isa => 'ArrayRef',
				   default => qw/ ip date user url comment highlight / );

#3has 'jspages'  => ( is => 'ro', isa => 'ArrayRef[Str]',
#				   default => qw/ url pagerank keywords semantic text / );

#has 'pages'   => ( is => 'rw', isa => 'relaxedJSON', trigger => \&_pages_set );

has 'docUsr'  => ( is => 'rw', isa => 'relaxedJSON' ); #trigger => \&_docUsr_set );

sub _get_content {    
    my $self = shift;    
    $self->browser->get( $self->browser->url );    
}

sub _set_storage {    
    my $self = shift;
    $self->_set_storage();
}

sub _docUsr_set {
    my $self = shift;
    $self->docUsr = map { $self->{$_} } @{$self->jsdocUsr};
    say Dumper $self->docUsr;
}

sub _init {
    
    my $self = shift;
    my ($url, $user, $pass, $ip, $comment, $highlight) = @_;
    
    $self->url       = $url;
    $self->user      = $user;
    $self->pass      = $pass;
    $self->ip        = $ip;
    $self->comments  = $comment;
    $self->highlight = $highlight;
    #$self->_get_content();
    $self->_set_storage();
    #$self->_commit();
    
}

my $test = Document::Stored->new; 
$test->_init('UrL','UsEr','PaSs','Ip','CoMmEnT','HiGhLiGhT');

1;

