package WebShot::InitLogger;
use strict;
use warnings;
use 5.010;

use Log::Any::Adapter;
use Log::Dispatch;
my $log = Log::Dispatch->new( outputs => [
    [ 'File',
      filename  => '/var/log/webshot.log',
      min_level => 'debug',
      newline   => 1,
      mode      => 'append',
    ],
]);
Log::Any::Adapter->set( 'Dispatch', dispatcher => $log );

1;
