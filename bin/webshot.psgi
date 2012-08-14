#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Plack::Builder;
use WebShot::Web;

my $app = 'WebShot::Web'->psgi_app;
builder {
    mount '/static' => builder {
        enable "NullLogger";
        enable "Plack::Middleware::Static",
            path => sub {1},
            root => "$FindBin::Bin/../root/static";
    };

    mount '/' => builder { $app };
};

