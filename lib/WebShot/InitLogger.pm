package WebShot::InitLogger;
use strict;
use warnings;
use 5.010;

use IO::Interactive qw(is_interactive);
use Log::Any::Adapter;
use Log::Log4perl;

if ( is_interactive() ) {
    Log::Log4perl::init(
      '/home/domm/perl/talks/logging/WebShot/log4perl.conf'
    );
}
else {
    Log::Log4perl::init(
      '/home/domm/perl/talks/logging/WebShot/log4perl_noninteractive.conf'
    );
}

Log::Any::Adapter->set('Log::Log4perl');
1;
