#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;
use FindBin;
use lib "$FindBin::Bin/../lib";

my $db_loc = "$FindBin::Bin/../root/webshot.db";
my $sql_file = "$FindBin::Bin/../sql/schema.sql";

system("sqlite3 $db_loc < $sql_file");
