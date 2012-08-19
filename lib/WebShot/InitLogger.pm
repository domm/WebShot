package WebShot::InitLogger;
use strict;
use warnings;
use 5.010;

use IO::Interactive qw(is_interactive);
use Log::Any::Adapter;
use Log::Dispatch;

if ( $ENV{HARNESS_ACTIVE} ) {
    Log::Any::Adapter->set( 'Test' );
}
else {
    my $log = Log::Dispatch->new(
        outputs => [
            [ 'File',
            filename  => '/var/log/webshot/log_dispatch.log',
            min_level => 'debug',
            mode      => 'append',
            ],
        ],
        callbacks => [
            sub {
                my %msg = @_;
                return sprintf(
                    "[%s] %s(%s): %s\n",
                    scalar localtime(time),
                    $0, $$,
                    $msg{message}
                )
            }
    ]);
    if ( is_interactive() ) {
        use Log::Dispatch::Screen;
        $log->add( Log::Dispatch::Screen->new(
            name      => 'screen',
            min_level => 'debug',
        ));
    }
    Log::Any::Adapter->set( 'Dispatch', dispatcher => $log );
}

1;
