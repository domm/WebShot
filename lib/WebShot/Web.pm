package WebShot::Web;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;
our $VERSION = '1.000';

use Catalyst qw/
    ConfigLoader
    Unicode::Encoding
    Static::Simple
/;

__PACKAGE__->config( 'Plugin::ConfigLoader' => { file => 'webshot.pl' } );

extends 'Catalyst';

__PACKAGE__->setup();

use Log::Dispatch;
my $log = Log::Dispatch->new( outputs => [
    [ 'File',
      filename  => '/var/log/webshot.log',
      min_level => 'debug',
      newline   => 1,
      mode      => 'append',
    ],
]);
__PACKAGE__->log($log);

