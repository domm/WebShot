package WebShot::InitLogger;
use strict;
use warnings;
use 5.010;

use Log::Any::Adapter;
use Log::Log4perl;
Log::Log4perl::init('/home/domm/perl/talks/logging/WebShot/log4perl.conf');
Log::Any::Adapter->set('Log::Log4perl');

1;
