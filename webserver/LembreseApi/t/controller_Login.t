use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'LembreseApi' }
BEGIN { use_ok 'LembreseApi::Controller::Login' }

ok( request('/login')->is_success, 'Request should succeed' );
done_testing();
