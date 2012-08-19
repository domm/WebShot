package WebShot::InitLogger;
use strict;
use warnings;
use 5.010;

use IO::Interactive qw(is_interactive);
use Log::Any::Adapter;

if ( $ENV{HARNESS_ACTIVE} ) {
    Log::Any::Adapter->set( 'Test' );
}
else {
    use Unix::Syslog qw(:macros);
    my $opts = is_interactive()
               ? LOG_PID|LOG_PERROR
               : LOG_PID;
    Log::Any::Adapter->set(
        'Syslog',
        options  => $opts,
        facility => LOG_LOCAL1
    );
}

1;
