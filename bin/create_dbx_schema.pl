#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;
use FindBin;
use lib "$FindBin::Bin/../lib";

use DBIx::Class::Schema::Loader 0.07010;

DBIx::Class::Schema::Loader::make_schema_at(
    'WebShot::Schema',
    {
        naming          => 'current',
        use_namespaces  => 1,
        use_moose       => 1,
        components      => [ 'TimeStamp', 'InflateColumn::DateTime', 'PK' ],
        generate_pod    => 0,
        dump_directory => "$FindBin::Bin/../lib",
    },
    ["dbi:SQLite:dbname=$FindBin::Bin/../root/webshot.db"],
);
